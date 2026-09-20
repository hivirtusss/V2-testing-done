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
    received_at: datetime

    class Config:
        from_attributes = True
