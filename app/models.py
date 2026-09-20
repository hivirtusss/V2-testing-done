from datetime import datetime

from pydantic import BaseModel, Field


class SMSWebhookPayload(BaseModel):
    sender: str = Field(..., description="SMS sender number or name")
    message: str = Field(..., description="SMS body text")
    device_name: str = Field(default="android", description="Device identifier")
    timestamp: datetime | None = Field(default=None, description="Optional SMS timestamp")


class SMSResponse(BaseModel):
    id: int
    sender: str
    message: str
    device_name: str
    device_id: int | None = None
    received_at: datetime

    class Config:
        from_attributes = True


class DeviceCreate(BaseModel):
    name: str = Field(..., min_length=1, max_length=128)
    api_key: str | None = Field(default=None, description="Optional per-device API key")


class DeviceResponse(BaseModel):
    id: int
    name: str
    is_active: bool
    last_seen: datetime | None
    sms_count: int = 0
    created_at: datetime

    class Config:
        from_attributes = True
