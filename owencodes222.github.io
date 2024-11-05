<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Fight Night Manager</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f4;
        }
        .container {
            width: 80%;
            margin: 0 auto;
        }
        h2 {
            color: #333;
        }
        .section {
            background-color: #fff;
            padding: 20px;
            margin: 20px 0;
            border-radius: 8px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        }
        label, input, select, textarea, button {
            display: block;
            margin: 10px 0;
            font-size: 16px;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 10px;
        }
        th, td {
            padding: 10px;
            border: 1px solid #ddd;
            text-align: center;
        }
        .admin-controls {
            display: none;
        }
        #logoutButton {
            display: none;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>Fight Night Manager</h1>

        <!-- Admin Login and Logout -->
        <button id="loginButton" onclick="loginAsAdmin()">Login as Admin</button>
        <button id="logoutButton" onclick="logoutAsAdmin()">Logout</button>

        <!-- Fighters Section -->
        <div class="section">
            <h2>Manage Fighters</h2>
            <form id="fighterForm" class="admin-controls">
                <label>Fighter Name:</label>
                <input type="text" id="fighterName" required>

                <label>Weight Class:</label>
                <select id="weightClass">
                    <option value="Featherweight">Featherweight</option>
                    <option value="Lightweight">Lightweight</option>
                    <option value="Heavyweight">Heavyweight</option>
                </select>

                <label>Weight (lbs):</label>
                <input type="number" id="weight" min="0" required>

                <label>Wins:</label>
                <input type="number" id="wins" min="0" required>

                <label>Losses:</label>
                <input type="number" id="losses" min="0" required>

                <label>Notes:</label>
                <textarea id="notes"></textarea>

                <button type="button" onclick="addFighter()">Add Fighter</button>
            </form>

            <h3>Fighter List</h3>
            <div>
                <h4>Featherweight</h4>
                <table id="featherweightTable">
                    <thead>
                        <tr>
                            <th>Name</th>
                            <th>Weight (lbs)</th>
                            <th>Record (W-L)</th>
                            <th>Notes</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody></tbody>
                </table>

                <h4>Lightweight</h4>
                <table id="lightweightTable">
                    <thead>
                        <tr>
                            <th>Name</th>
                            <th>Weight (lbs)</th>
                            <th>Record (W-L)</th>
                            <th>Notes</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody></tbody>
                </table>

                <h4>Heavyweight</h4>
                <table id="heavyweightTable">
                    <thead>
                        <tr>
                            <th>Name</th>
                            <th>Weight (lbs)</th>
                            <th>Record (W-L)</th>
                            <th>Notes</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody></tbody>
                </table>
            </div>
        </div>

        <!-- Fight Night Section -->
        <div class="section">
            <h2>Plan Fight Night</h2>
            <form id="fightNightForm" class="admin-controls">
                <label>Week (YYYY-MM-DD to YYYY-MM-DD):</label>
                <input type="week" id="eventWeek" required>

                <label>Fighter 1:</label>
                <select id="fighter1"></select>

                <label>Fighter 2:</label>
                <select id="fighter2"></select>

                <button type="button" onclick="addFightNight()">Add Fight</button>
            </form>

            <h3>Fight Night Schedule by Week</h3>
            <div id="fightNightList">
                <!-- Fight nights by week will be listed here dynamically -->
            </div>
        </div>
    </div>

    <script>
        const fighters = [];
        const fightNights = {};
        const adminPassword = "kavyisshort44"; // Set your password here
        let isAdmin = false;

        function loginAsAdmin() {
            const password = prompt("Enter admin password:");
            if (password === adminPassword) {
                isAdmin = true;
                document.querySelectorAll('.admin-controls').forEach(el => el.style.display = 'block');
                document.getElementById('loginButton').style.display = 'none';
                document.getElementById('logoutButton').style.display = 'block';
                renderFighters();
                renderFightNights();
            } else {
                alert("Incorrect password.");
            }
        }

        function logoutAsAdmin() {
            isAdmin = false;
            document.querySelectorAll('.admin-controls').forEach(el => el.style.display = 'none');
            document.getElementById('loginButton').style.display = 'block';
            document.getElementById('logoutButton').style.display = 'none';
            renderFighters();
            renderFightNights();
        }

        function addFighter() {
            const name = document.getElementById('fighterName').value;
            const weightClass = document.getElementById('weightClass').value;
            const weight = parseInt(document.getElementById('weight').value);
            const wins = parseInt(document.getElementById('wins').value);
            const losses = parseInt(document.getElementById('losses').value);
            const notes = document.getElementById('notes').value;

            const fighter = { name, weightClass, weight, wins, losses, notes };
            fighters.push(fighter);
            renderFighters();
            populateFighterOptions();
            document.getElementById('fighterForm').reset();
        }

        function renderFighters() {
            const featherweightTable = document.getElementById('featherweightTable').querySelector('tbody');
            const lightweightTable = document.getElementById('lightweightTable').querySelector('tbody');
            const heavyweightTable = document.getElementById('heavyweightTable').querySelector('tbody');

            featherweightTable.innerHTML = '';
            lightweightTable.innerHTML = '';
            heavyweightTable.innerHTML = '';

            fighters.forEach((fighter, index) => {
                const row = document.createElement('tr');
                row.innerHTML = `
                    <td>${fighter.name}</td>
                    <td>${fighter.weight} lbs</td>
                    <td>${fighter.wins} - ${fighter.losses}</td>
                    <td>${fighter.notes}</td>
                    <td>
                        ${isAdmin ? `<button onclick="editFighter(${index})">Edit</button>
                        <button onclick="deleteFighter(${index})">Delete</button>` : 'View Only'}
                    </td>
                `;

                if (fighter.weightClass === 'Featherweight') {
                    featherweightTable.appendChild(row);
                } else if (fighter.weightClass === 'Lightweight') {
                    lightweightTable.appendChild(row);
                } else if (fighter.weightClass === 'Heavyweight') {
                    heavyweightTable.appendChild(row);
                }
            });
        }

        function editFighter(index) {
            if (!isAdmin) return;
            const fighter = fighters[index];
            document.getElementById('fighterName').value = fighter.name;
            document.getElementById('weightClass').value = fighter.weightClass;
            document.getElementById('weight').value = fighter.weight;
            document.getElementById('wins').value = fighter.wins;
            document.getElementById('losses').value = fighter.losses;
            document.getElementById('notes').value = fighter.notes;
            fighters.splice(index, 1);
        }

        function deleteFighter(index) {
            if (!isAdmin) return;
            fighters.splice(index, 1);
            renderFighters();
            populateFighterOptions();
        }

        function addFightNight() {
            if (!isAdmin) return;
            const eventWeek = document.getElementById('eventWeek').value;
            const fighter1 = document.getElementById('fighter1').value;
            const fighter2 = document.getElementById('fighter2').value;

            if (fighter1 === fighter2) {
                alert("Choose two different fighters!");
                return;
            }

            const fight = { fighter1, fighter2, isPast: checkIfPast(eventWeek), score: null };

            if (!fightNights[eventWeek]) {
                fightNights[eventWeek] = [];
            }

            fightNights[eventWeek].push(fight);
            renderFightNights();
        }

        function renderFightNights() {
            const fightNightList = document.getElementById('fightNightList');
            fightNightList.innerHTML = '';

            for (const week in fightNights) {
                const fights = fightNights[week];
                const fightList = document.createElement('div');
                fightList.innerHTML = `<h4>Week: ${week}</h4>`;
                fights.forEach((fight, index) => {
                    const fightItem = document.createElement('div');
                    fightItem.innerHTML = `
                        <p>${fight.fighter1} vs ${fight.fighter2} - ${fight.isPast ? (fight.score ? `Score: ${fight.score}` : `<input type="text" placeholder="Enter Score" id="scoreInput${week}${index}"> <button onclick="addScore('${week}', ${index})">Submit Score</button>`) : 'Upcoming'}</p>
                    `;
                    fightList.appendChild(fightItem);
                });
                fightNightList.appendChild(fightList);
            }
        }

        function addScore(week, index) {
            const scoreInput = document.getElementById(`scoreInput${week}${index}`);
            const score = scoreInput.value;
            if (score) {
                fightNights[week][index].score = score;
                renderFightNights();
            }
        }

        function checkIfPast(week) {
            const selectedDate = new Date(week.split('-W')[0]);
            const currentDate = new Date();
            return selectedDate < currentDate;
        }

        function populateFighterOptions() {
            const fighter1Select = document.getElementById('fighter1');
            const fighter2Select = document.getElementById('fighter2');

            fighter1Select.innerHTML = '';
            fighter2Select.innerHTML = '';

            fighters.forEach(fighter => {
                const option1 = document.createElement('option');
                option1.value = fighter.name;
                option1.textContent = fighter.name;

                const option2 = option1.cloneNode(true);

                fighter1Select.appendChild(option1);
                fighter2Select.appendChild(option2);
            });
        }

        document.addEventListener("DOMContentLoaded", () => {
            populateFighterOptions();
        });
    </script>
</body>
</html>
