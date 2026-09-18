from sqlalchemy import Column, Integer, String, Float, DateTime
from database import Base
import datetime

class Patient(Base):
    __tablename__ = "patients"

    id = Column(Integer, primary_key=True, index=True)
    name = Column(String, index=True)
    age = Column(Integer)
    language_pref = Column(String, default="Assamese") # Assamese, Bengali, Bodo, etc.
    caregiver_id = Column(Integer, index=True)

class GameSession(Base):
    __tablename__ = "game_sessions"

    id = Column(Integer, primary_key=True, index=True)
    patient_id = Column(Integer, index=True)
    game_type = Column(String) # "MemoryMatch", "SpotDifference"
    score = Column(Float)
    duration_seconds = Column(Integer)
    difficulty_level = Column(Integer)
    synced_at = Column(DateTime, default=datetime.datetime.utcnow)

class ReminderLog(Base):
    __tablename__ = "reminder_logs"

    id = Column(Integer, primary_key=True, index=True)
    patient_id = Column(Integer, index=True)
    reminder_type = Column(String) # "Medication", "Hydration"
    status = Column(String) # "Completed", "Missed"
    timestamp = Column(DateTime)
