// app.js
// Mock data fetching from the FastAPI backend. In production, this uses fetch() with JWT Auth.

document.addEventListener("DOMContentLoaded", () => {
    // 1. Mock Data Fetch from FastAPI backend
    const mockData = {
        total_games_played: 24,
        average_score: 78.5,
        missed_reminders: 2,
        trend_data: [65, 70, 68, 75, 82, 78, 85], // Last 7 days
        recent_logs: [
            "✅ 08:00 AM - Morning Meds (Done)",
            "🎮 10:15 AM - Memory Match (Score: 85)",
            "❌ 01:00 PM - Hydration (Missed)",
            "🎮 04:30 PM - Spot Difference (Score: 72)",
        ]
    };

    // 2. Populate KPIs
    document.getElementById("totalGames").textContent = mockData.total_games_played;
    document.getElementById("avgScore").textContent = mockData.average_score + "%";
    document.getElementById("missedRoutines").textContent = mockData.missed_reminders;

    // 3. Security / Alert Engine
    // If missed routines > 2 or sudden score drop detected, show alert to caregiver.
    if (mockData.missed_reminders >= 2) {
        const alertBanner = document.getElementById("alertBanner");
        alertBanner.classList.add("active");
        document.getElementById("alertMessage").textContent = 
            `⚠️ Alert: Patient has missed \${mockData.missed_reminders} routine reminders today. Please call to check in.`;
    }

    // 4. Render Cognitive Trend Chart using Chart.js
    const ctx = document.getElementById('scoreChart').getContext('2d');
    new Chart(ctx, {
        type: 'line',
        data: {
            labels: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
            datasets: [{
                label: 'Cognitive Score (%)',
                data: mockData.trend_data,
                borderColor: '#00695c',
                backgroundColor: 'rgba(0, 105, 92, 0.1)',
                borderWidth: 3,
                fill: true,
                tension: 0.4
            }]
        },
        options: {
            responsive: true,
            scales: {
                y: { beginAtZero: false, min: 40, max: 100 }
            }
        }
    });

    // 5. Populate Activity Log
    const logContainer = document.getElementById("activityLog");
    mockData.recent_logs.forEach(log => {
        let li = document.createElement("li");
        li.textContent = log;
        li.style.borderBottom = "1px solid #ddd";
        li.style.padding = "10px 0";
        logContainer.appendChild(li);
    });
});
