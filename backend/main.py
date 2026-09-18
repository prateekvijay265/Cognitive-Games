from fastapi import FastAPI, Depends, HTTPException
from sqlalchemy.orm import Session
from typing import List
from pydantic import BaseModel
import models, database
from database import engine

models.Base.metadata.create_all(bind=engine)

app = FastAPI(title="NeuroNER API", description="Backend for NeuroNER MVP")

# Pydantic models for request/response
class GameSessionCreate(BaseModel):
    patient_id: int
    game_type: str
    score: float
    duration_seconds: int
    difficulty_level: int

class ReminderLogCreate(BaseModel):
    patient_id: int
    reminder_type: str
    status: str

@app.post("/sync/games/")
def sync_game_session(session: GameSessionCreate, db: Session = Depends(database.get_db)):
    db_session = models.GameSession(**session.dict())
    db.add(db_session)
    db.commit()
    db.refresh(db_session)
    return {"status": "success", "session_id": db_session.id}

@app.post("/sync/reminders/")
def sync_reminder_log(log: ReminderLogCreate, db: Session = Depends(database.get_db)):
    import datetime
    db_log = models.ReminderLog(**log.dict(), timestamp=datetime.datetime.utcnow())
    db.add(db_log)
    db.commit()
    db.refresh(db_log)
    return {"status": "success", "log_id": db_log.id}

@app.get("/caregiver/{patient_id}/dashboard")
def get_dashboard_stats(patient_id: int, db: Session = Depends(database.get_db)):
    # Returns summary of the patient's stats for the caregiver web dashboard
    sessions = db.query(models.GameSession).filter(models.GameSession.patient_id == patient_id).all()
    reminders = db.query(models.ReminderLog).filter(models.ReminderLog.patient_id == patient_id).all()
    
    return {
        "total_games_played": len(sessions),
        "average_score": sum([s.score for s in sessions]) / len(sessions) if sessions else 0,
        "missed_reminders": len([r for r in reminders if r.status == "Missed"])
    }
