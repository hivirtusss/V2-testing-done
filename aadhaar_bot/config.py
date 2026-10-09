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
    aadhaar_provider: str = "uidai"  # uidai = built-in MyAadhaar bridge | remote = external URL
    aadhaar_backend_url: str = ""
    aadhaar_backend_key: str = ""
    aadhaar_mock_mode: bool = False
    aadhaar_db_url: str = "sqlite:///./aadhaar_bot.db"
    aadhaar_notify_chat_id: str = ""
    uidai_bridge_host: str = "127.0.0.1"
    uidai_bridge_port: int = 8790
    uidai_tathya_base: str = "https://tathya.uidai.gov.in"
    uidai_http_timeout: float = 120.0
    uidai_captcha_length: str = "6"
    uidai_captcha_type: str = "2"
    uidai_captcha_url: str = ""
    uidai_retrieve_url: str = ""
    uidai_eaadhaar_download_url: str = ""
    uidai_user_agent: str = (
        "Mozilla/5.0 (Linux; Android 16; Mobile) AppleWebKit/537.36 "
        "(KHTML, like Gecko) Chrome/144.0.0.0 Mobile Safari/537.36"
    )
    uidai_captcha_solver: str = "ddddocr"  # ddddocr | 2captcha
    uidai_2captcha_key: str = ""
    aadhaar_pdf_year_from: int = 1960
    aadhaar_pdf_year_to: int = 2025
    aadhaar_verify_timeout: float = 150.0

    @property
    def owner_id_set(self) -> set[int]:
        out: set[int] = set()
        for part in self.aadhaar_owner_ids.replace(" ", "").split(","):
            if part.isdigit():
                out.add(int(part))
        return out

    @property
    def effective_backend_url(self) -> str:
        if self.aadhaar_backend_url.strip():
            return self.aadhaar_backend_url.strip()
        if self.aadhaar_provider.lower() == "uidai":
            return f"http://{self.uidai_bridge_host}:{self.uidai_bridge_port}"
        return ""


@lru_cache
def get_settings() -> Settings:
    return Settings()
