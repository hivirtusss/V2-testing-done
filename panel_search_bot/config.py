from functools import lru_cache

from pydantic_settings import BaseSettings, SettingsConfigDict


class Settings(BaseSettings):
    model_config = SettingsConfigDict(env_file=".env", env_file_encoding="utf-8", extra="ignore")

    panel_search_bot_token: str = ""
    panel_search_owner_ids: str = ""
    panel_search_auth_key: str = "astik"
    panel_search_database_url: str = "sqlite:///./panel_search.db"
    panel_search_concurrency: int = 64
    panel_search_max_workers: int = 0  # 0 = use concurrency value
    panel_search_fetch_timeout: float = 1.6
    panel_search_skip_live_if_cached: bool = False
    panel_search_both_skip_uncached_live: bool = False
    panel_search_min_cached_dbs_for_fast_both: int = 25
    panel_search_variant_limit: int = 2
    panel_search_parallel_subpaths: int = 8
    panel_search_fetch_batch_size: int = 48  # legacy; fetch_many runs all URLs under semaphore
    panel_search_ui_edit_interval: float = 1.0
    panel_search_per_db_timeout: float = 3.5
    panel_search_max_scan_sec: float = 175.0
    panel_search_skip_offline_hours: float = 0.0  # 0 = always re-probe; set 12 on VPS after stable cache
    panel_search_balance_high_min: float = 70_000.0
    panel_search_balance_high_max: float = 10_000_000.0  # 1 crore
    panel_search_balance_low_min: float = 1_000.0
    # 0 = unlimited; else caps "All Time" searches (avoids 2021-era SMS dumps).
    panel_search_alltime_max_days: int = 0
    panel_search_leak_file: str = ""
    panel_search_notify_chat_id: str = ""

    @property
    def worker_count(self) -> int:
        if self.panel_search_max_workers and self.panel_search_max_workers > 0:
            return self.panel_search_max_workers
        return max(self.panel_search_concurrency, 16)

    @property
    def owner_id_set(self) -> set[int]:
        ids: set[int] = set()
        for part in self.panel_search_owner_ids.replace(" ", "").split(","):
            if part.isdigit():
                ids.add(int(part))
        return ids


@lru_cache
def get_settings() -> Settings:
    return Settings()
