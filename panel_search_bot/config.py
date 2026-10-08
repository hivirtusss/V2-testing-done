from functools import lru_cache

from pydantic_settings import BaseSettings, SettingsConfigDict


class Settings(BaseSettings):
    model_config = SettingsConfigDict(env_file=".env", env_file_encoding="utf-8", extra="ignore")

    panel_search_bot_token: str = ""
    panel_search_owner_ids: str = ""
    panel_search_auth_key: str = "astik"
    panel_search_database_url: str = "sqlite:///./panel_search.db"
    panel_search_concurrency: int = 12
    panel_search_fetch_timeout: float = 12.0
    panel_search_leak_file: str = ""

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
