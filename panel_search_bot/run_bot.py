#!/usr/bin/env python3
import logging

from panel_search_bot.bot import main

if __name__ == "__main__":
    logging.basicConfig(level=logging.INFO, format="%(asctime)s %(levelname)s %(name)s: %(message)s")
    main()
