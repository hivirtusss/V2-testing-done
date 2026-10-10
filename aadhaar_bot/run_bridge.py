#!/usr/bin/env python3
import uvicorn

from aadhaar_bot.config import get_settings


def main() -> None:
    s = get_settings()
    workers = max(1, min(int(s.uidai_bridge_workers), 32))
    uvicorn.run(
        "aadhaar_bot.bridge.server:app",
        host=s.uidai_bridge_host,
        port=s.uidai_bridge_port,
        reload=False,
        workers=workers,
    )


if __name__ == "__main__":
    main()
