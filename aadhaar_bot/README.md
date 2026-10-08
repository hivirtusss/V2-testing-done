# Aadhaar Document Bot (Telegram)

Dynamo-style flow: mobile → gender → name → OTP1 → OTP2 → extraction + PDF.

**UIDAI is not scraped from this repo.** The bot calls **your backend** (`AADHAAR_BACKEND_URL`) where captcha and DOB-less lookup run.

## Run

```bash
cp .env.aadhaar.example .env.aadhaar
# set AADHAAR_BOT_TOKEN
chmod +x start_aadhaar_bot.sh stop_aadhaar_bot.sh
./start_aadhaar_bot.sh
```

**Access:** Sirf owner `/approve` ke baad. **1 successful Aadhaar = 1 credit** (`/addcredits`). Owner = **Unlimited**.

**Live verify:** Pehle `POST /v1/lookup/verify` — galat name/number par OTP **nahi** bhejta.

Mock (bina `AADHAAR_BACKEND_URL`): sirf demo pair `9520728207` + `SHADAB`. Baaki reject.

Demo OTP: `541679` / `670299`.

## Backend API

All POST, JSON, optional `Authorization: Bearer <AADHAAR_BACKEND_KEY>`.

### `POST /v1/lookup/verify` (required — Umang / uidai.gov.in bridge)

Same body as start. Must return `ok: false` if no Aadhaar on that mobile+name.

```json
{ "ok": true, "message": "Record found", "session_id": "optional" }
```

### `POST /v1/lookup/start`

```json
{
  "mobile": "9520728207",
  "gender": "male",
  "holder_name": "Shadab",
  "name": "SHADAB",
  "fetch_by_name": true,
  "manual_name": true,
  "skip_dob": true
}
```

`holder_name` = user typed (card jaisa). `name` = uppercase match key. `manual_name` = user chose **Enter Name Manually**.

Response:

```json
{ "ok": true, "message": "OTP 1 sent", "session_id": "abc123" }
```

### `POST /v1/lookup/otp1`

```json
{ "session_id": "abc123", "otp": "541679" }
```

Response:

```json
{ "ok": true, "message": "OTP 2 sent", "session_id": "abc123" }
```

### `POST /v1/lookup/otp2`

```json
{ "session_id": "abc123", "otp": "670299" }
```

Response:

```json
{
  "ok": true,
  "message": "Done",
  "aadhaar_masked": "9815 7689 9641",
  "name": "Shadab",
  "numeric_id": "0231191050808620260509095954",
  "pdf_password": "SHAD2003",
  "phone": "9520728207",
  "pdf_base64": "<optional PDF bytes base64>"
}
```

Wire your Google Drive / VPS bridge to these endpoints.

## Side bots

`./stop_side_bots.sh` stops Panel Search + Aadhaar processes only; Virtus code is not changed.
