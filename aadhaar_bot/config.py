from functools import lru_cache

from pydantic_settings import BaseSettings, SettingsConfigDict


class Settings(BaseSettings):
    model_config = SettingsConfigDict(
        env_file=(".env.aadhaar", ".env"),
        env_file_encoding="utf-8",
        extra="ignore",
    )

    aadhaar_bot_token: str = ""
    aadhaar_owner_ids: str = ""
    aadhaar_backend_url: str = ""
    aadhaar_backend_key: str = ""
    aadhaar_mock_mode: bool = True
    aadhaar_db_url: str = "sqlite:///./aadhaar_bot.db"
    aadhaar_notify_chat_id: str = ""

    @property
    def owner_id_set(self) -> set[int]:
        out: set[int] = set()
        for part in self.aadhaar_owner_ids.replace(" ", "").split(","):
            if part.isdigit():
                out.add(int(part))
        return out


@lru_cache
def get_settings() -> Settings:
    return Settings()
