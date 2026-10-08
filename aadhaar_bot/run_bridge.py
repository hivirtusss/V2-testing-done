#!/usr/bin/env python3
import uvicorn

from aadhaar_bot.config import get_settings


def main() -> None:
    s = get_settings()
    uvicorn.run(
        "aadhaar_bot.bridge.server:app",
        host=s.uidai_bridge_host,
        port=s.uidai_bridge_port,
        reload=False,
    )


if __name__ == "__main__":
    main()
