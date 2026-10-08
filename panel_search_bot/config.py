from functools import lru_cache

from pydantic_settings import BaseSettings, SettingsConfigDict


class Settings(BaseSettings):
    model_config = SettingsConfigDict(env_file=".env", env_file_encoding="utf-8", extra="ignore")

    panel_search_bot_token: str = ""
    panel_search_owner_ids: str = ""
    panel_search_auth_key: str = "astik"
    panel_search_database_url: str = "sqlite:///./panel_search.db"
    panel_search_concurrency: int = 128
    panel_search_max_workers: int = 192
    panel_search_fetch_timeout: float = 4.5
    panel_search_url_timeout: float = 12.0
    panel_search_max_sms_per_db: int = 2500
    panel_search_max_fetch_bytes: int = 4 * 1024 * 1024
    panel_search_max_url_variants: int = 2
    panel_search_skip_live_if_cached: bool = True
    panel_search_cache_yield: int = 8000
    panel_search_defer_cache_write: bool = True
    panel_search_skip_offline_hours: float = 12.0
    panel_search_live_fetch: bool = True
    panel_search_balance_high_min: float = 70_000.0
    panel_search_balance_high_max: float = 10_000_000.0  # 1 crore
    panel_search_balance_low_min: float = 1_000.0
    panel_search_leak_file: str = ""
    panel_search_notify_chat_id: str = ""

    @property
    def worker_count(self) -> int:
        if self.panel_search_max_workers and self.panel_search_max_workers > 0:
            return min(self.panel_search_max_workers, 256)
        return min(max(self.panel_search_concurrency, 32), 256)

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
