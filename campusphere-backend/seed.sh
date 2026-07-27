#!/bin/bash

# ==============================================
# CampuSphere - Club & Event Data Seeder Script
# ==============================================

BASE_URL="http://localhost:8080"
echo "=========================================="
echo " CampuSphere Club & Event Data Seeder"
echo "=========================================="

# ---- Step 0: Register the seed user (idempotent) ----
echo ""
echo ">>> Step 0: Registering seed user test@example.com..."
REGISTER_RESPONSE=$(curl -s -X POST "$BASE_URL/api/auth/register" \
  -H "Content-Type: application/json" \
  -d '{"email": "test@example.com", "password": "12345", "role": "ADMIN", "mobileDeviceToken": ""}')
echo "Register Response: $REGISTER_RESPONSE"

# ---- Step 1: Login to get JWT token ----
echo ""
echo ">>> Step 1: Logging in with test@example.com..."
LOGIN_RESPONSE=$(curl -s -X POST "$BASE_URL/api/auth/login" \
  -H "Content-Type: application/json" \
  -d '{"email": "test@example.com", "password": "12345"}')

echo "Login Response: $LOGIN_RESPONSE"

TOKEN=$(echo "$LOGIN_RESPONSE" | python3 -c "import sys, json; print(json.load(sys.stdin)['data'])" 2>/dev/null)

if [ -z "$TOKEN" ]; then
  echo "ERROR: Failed to extract JWT token. Exiting."
  exit 1
fi

echo "Token acquired: ${TOKEN:0:40}..."
AUTH_HEADER="Authorization: Bearer $TOKEN"

# ---- Step 2: Register student users via /api/auth/register ----
echo ""
echo "=========================================="
echo ">>> Step 2: Registering student users..."
echo "=========================================="

EMAILS=("alex.miller@university.edu" "sarah.johnson@university.edu" "michael.chen@university.edu" "emily.davis@university.edu" "david.anderson@university.edu")

for EMAIL in "${EMAILS[@]}"; do
  echo "  Registering $EMAIL..."
  RESPONSE=$(curl -s -X POST "$BASE_URL/api/auth/register" \
    -H "Content-Type: application/json" \
    -d "{\"email\": \"$EMAIL\", \"password\": \"12345\", \"role\": \"STUDENT\", \"mobileDeviceToken\": \"\"}")
  echo "  Response: $RESPONSE"
done

# ---- Step 3: Create Student profiles ----
echo ""
echo "=========================================="
echo ">>> Step 3: Creating Student profiles..."
echo "=========================================="

declare -a STUDENT_IDS

STUDENTS=(
  '{"name":"Alex","surname":"Miller","email":"alex.miller@university.edu","phone":"+15551234567","profilePictureURL":"https://i.pravatar.cc/150?img=1","department":"COMPUTER_ENGINEERING","socialLinks":[]}'
  '{"name":"Sarah","surname":"Johnson","email":"sarah.johnson@university.edu","phone":"+15552345678","profilePictureURL":"https://i.pravatar.cc/150?img=5","department":"ELECTRICAL_ENGINEERING","socialLinks":[]}'
  '{"name":"Michael","surname":"Chen","email":"michael.chen@university.edu","phone":"+15553456789","profilePictureURL":"https://i.pravatar.cc/150?img=3","department":"MATHEMATICS","socialLinks":[]}'
  '{"name":"Emily","surname":"Davis","email":"emily.davis@university.edu","phone":"+15554567890","profilePictureURL":"https://i.pravatar.cc/150?img=9","department":"PHYSICS","socialLinks":[]}'
  '{"name":"David","surname":"Anderson","email":"david.anderson@university.edu","phone":"+15555678901","profilePictureURL":"https://i.pravatar.cc/150?img=7","department":"BUSINESS_ADMINISTRATION","socialLinks":[]}'
)

for i in "${!STUDENTS[@]}"; do
  echo ""
  echo "  Creating student profile $((i+1))..."
  RESPONSE=$(curl -s -X POST "$BASE_URL/api/student/create" \
    -H "Content-Type: application/json" \
    -H "$AUTH_HEADER" \
    -d "${STUDENTS[$i]}")
  echo "  Response: $RESPONSE"

  SID=$(echo "$RESPONSE" | python3 -c "import sys, json; print(json.load(sys.stdin)['data']['id'])" 2>/dev/null)
  if [ -n "$SID" ]; then
    STUDENT_IDS+=("$SID")
    echo "  Student ID: $SID"
  else
    echo "  WARNING: Could not extract student ID"
  fi
done

echo ""
echo "Created ${#STUDENT_IDS[@]} students."

# ---- Step 3b: Add Social Links to Students ----
echo ""
echo "=========================================="
echo ">>> Step 3b: Adding Social Links to Students..."
echo "=========================================="

if [ ${#STUDENT_IDS[@]} -ge 5 ]; then
  # Alex
  curl -s -X POST "$BASE_URL/api/student/addSocialLinkToStudent?studentId=${STUDENT_IDS[0]}&url=https://linkedin.com/in/alexmiller&platform=LINKEDIN" -H "$AUTH_HEADER" > /dev/null
  curl -s -X POST "$BASE_URL/api/student/addSocialLinkToStudent?studentId=${STUDENT_IDS[0]}&url=https://github.com/alexmiller&platform=GITHUB" -H "$AUTH_HEADER" > /dev/null
  
  # Sarah
  curl -s -X POST "$BASE_URL/api/student/addSocialLinkToStudent?studentId=${STUDENT_IDS[1]}&url=https://linkedin.com/in/sarahjohnson&platform=LINKEDIN" -H "$AUTH_HEADER" > /dev/null
  curl -s -X POST "$BASE_URL/api/student/addSocialLinkToStudent?studentId=${STUDENT_IDS[1]}&url=https://twitter.com/sarahj_eng&platform=X" -H "$AUTH_HEADER" > /dev/null
  
  # Michael
  curl -s -X POST "$BASE_URL/api/student/addSocialLinkToStudent?studentId=${STUDENT_IDS[2]}&url=https://linkedin.com/in/michaelchen&platform=LINKEDIN" -H "$AUTH_HEADER" > /dev/null
  curl -s -X POST "$BASE_URL/api/student/addSocialLinkToStudent?studentId=${STUDENT_IDS[2]}&url=https://github.com/mchen_math&platform=GITHUB" -H "$AUTH_HEADER" > /dev/null

  # Emily
  curl -s -X POST "$BASE_URL/api/student/addSocialLinkToStudent?studentId=${STUDENT_IDS[3]}&url=https://linkedin.com/in/emilydavis&platform=LINKEDIN" -H "$AUTH_HEADER" > /dev/null
  curl -s -X POST "$BASE_URL/api/student/addSocialLinkToStudent?studentId=${STUDENT_IDS[3]}&url=https://twitter.com/emily_physics&platform=X" -H "$AUTH_HEADER" > /dev/null

  # David
  curl -s -X POST "$BASE_URL/api/student/addSocialLinkToStudent?studentId=${STUDENT_IDS[4]}&url=https://linkedin.com/in/davidanderson&platform=LINKEDIN" -H "$AUTH_HEADER" > /dev/null
  curl -s -X POST "$BASE_URL/api/student/addSocialLinkToStudent?studentId=${STUDENT_IDS[4]}&url=https://twitter.com/david_biz&platform=X" -H "$AUTH_HEADER" > /dev/null

  echo "  Social links added successfully."
else
  echo "  Not enough students created to add social links."
fi


# ---- Step 4: Create Clubs ----
echo ""
echo "=========================================="
echo ">>> Step 4: Creating Student Clubs..."
echo "=========================================="

declare -a CLUB_IDS

CLUBS=(
  '{"name":"CampuSphere Tech Club","description":"A community for tech enthusiasts to explore software development, AI, and cutting-edge technologies through workshops and hackathons.","logoURL":"https://img.icons8.com/fluency/96/laptop-coding.png"}'
  '{"name":"Robotics & Innovation Society","description":"Hands-on robotics projects, Arduino/Raspberry Pi workshops, and participation in national robotics competitions.","logoURL":"https://img.icons8.com/fluency/96/robot-2.png"}'
  '{"name":"Debate & Public Speaking Club","description":"Sharpen your argumentation and public speaking skills through weekly debates, Model UN simulations, and speech tournaments.","logoURL":"https://img.icons8.com/fluency/96/speaker.png"}'
  '{"name":"Entrepreneurship Hub","description":"From idea to startup – pitch nights, mentorship programs, and networking events to fuel your entrepreneurial journey.","logoURL":"https://img.icons8.com/fluency/96/rocket.png"}'
  '{"name":"Photography & Visual Arts Club","description":"Capture the campus through your lens. Weekly photo walks, editing workshops, and semester-end exhibitions.","logoURL":"https://img.icons8.com/fluency/96/camera.png"}'
)

for i in "${!CLUBS[@]}"; do
  echo ""
  echo "  Creating club $((i+1))..."
  RESPONSE=$(curl -s -X POST "$BASE_URL/api/clubs" \
    -H "Content-Type: application/json" \
    -H "$AUTH_HEADER" \
    -d "${CLUBS[$i]}")
  echo "  Response: $RESPONSE"

  CID=$(echo "$RESPONSE" | python3 -c "import sys, json; print(json.load(sys.stdin)['data']['id'])" 2>/dev/null)
  if [ -n "$CID" ]; then
    CLUB_IDS+=("$CID")
    echo "  Club ID: $CID"
  else
    echo "  WARNING: Could not extract club ID"
  fi
done

echo ""
echo "Created ${#CLUB_IDS[@]} clubs."

# ---- Step 5: GET all clubs ----
echo ""
echo "=========================================="
echo ">>> Step 5: GET all clubs..."
echo "=========================================="
curl -s -X GET "$BASE_URL/api/clubs" \
  -H "$AUTH_HEADER" | python3 -m json.tool

# ---- Step 6: GET club by ID ----
echo ""
echo "=========================================="
echo ">>> Step 6: GET club by ID (first club)..."
echo "=========================================="
if [ ${#CLUB_IDS[@]} -gt 0 ]; then
  curl -s -X GET "$BASE_URL/api/clubs/${CLUB_IDS[0]}" \
    -H "$AUTH_HEADER" | python3 -m json.tool
fi

# ---- Step 7: UPDATE club ----
echo ""
echo "=========================================="
echo ">>> Step 7: UPDATE club (first club)..."
echo "=========================================="
if [ ${#CLUB_IDS[@]} -gt 0 ]; then
  RESPONSE=$(curl -s -X PUT "$BASE_URL/api/clubs/${CLUB_IDS[0]}" \
    -H "Content-Type: application/json" \
    -H "$AUTH_HEADER" \
    -d '{"description":"UPDATED: The premier tech community on campus – now featuring AI study groups, open-source contributions, and monthly hackathons!"}')
  echo "$RESPONSE" | python3 -m json.tool
fi

# ---- Step 8: Add Members to Clubs ----
echo ""
echo "=========================================="
echo ">>> Step 8: Adding members to clubs..."
echo "=========================================="

if [ ${#STUDENT_IDS[@]} -ge 5 ] && [ ${#CLUB_IDS[@]} -ge 5 ]; then

  # Tech Club: Alex=PRESIDENT, Sarah=VICE_PRESIDENT, Michael=MEMBER
  echo "  Adding Alex as PRESIDENT of Tech Club..."
  curl -s -X POST "$BASE_URL/api/clubs/${CLUB_IDS[0]}/members/${STUDENT_IDS[0]}" \
    -H "Content-Type: application/json" -H "$AUTH_HEADER" -d '"PRESIDENT"' | python3 -m json.tool

  echo "  Adding Sarah as VICE_PRESIDENT of Tech Club..."
  curl -s -X POST "$BASE_URL/api/clubs/${CLUB_IDS[0]}/members/${STUDENT_IDS[1]}" \
    -H "Content-Type: application/json" -H "$AUTH_HEADER" -d '"VICE_PRESIDENT"' | python3 -m json.tool

  echo "  Adding Michael as MEMBER of Tech Club..."
  curl -s -X POST "$BASE_URL/api/clubs/${CLUB_IDS[0]}/members/${STUDENT_IDS[2]}" \
    -H "Content-Type: application/json" -H "$AUTH_HEADER" -d '"MEMBER"' | python3 -m json.tool

  # Robotics: Sarah=PRESIDENT, David=SECRETARY
  echo "  Adding Sarah as PRESIDENT of Robotics Society..."
  curl -s -X POST "$BASE_URL/api/clubs/${CLUB_IDS[1]}/members/${STUDENT_IDS[1]}" \
    -H "Content-Type: application/json" -H "$AUTH_HEADER" -d '"PRESIDENT"' | python3 -m json.tool

  echo "  Adding David as SECRETARY of Robotics Society..."
  curl -s -X POST "$BASE_URL/api/clubs/${CLUB_IDS[1]}/members/${STUDENT_IDS[4]}" \
    -H "Content-Type: application/json" -H "$AUTH_HEADER" -d '"SECRETARY"' | python3 -m json.tool

  # Debate: Emily=PRESIDENT, Alex=MEMBER
  echo "  Adding Emily as PRESIDENT of Debate Club..."
  curl -s -X POST "$BASE_URL/api/clubs/${CLUB_IDS[2]}/members/${STUDENT_IDS[3]}" \
    -H "Content-Type: application/json" -H "$AUTH_HEADER" -d '"PRESIDENT"' | python3 -m json.tool

  echo "  Adding Alex as MEMBER of Debate Club..."
  curl -s -X POST "$BASE_URL/api/clubs/${CLUB_IDS[2]}/members/${STUDENT_IDS[0]}" \
    -H "Content-Type: application/json" -H "$AUTH_HEADER" -d '"MEMBER"' | python3 -m json.tool

  # Entrepreneurship: David=PRESIDENT, Michael=TREASURER
  echo "  Adding David as PRESIDENT of Entrepreneurship Hub..."
  curl -s -X POST "$BASE_URL/api/clubs/${CLUB_IDS[3]}/members/${STUDENT_IDS[4]}" \
    -H "Content-Type: application/json" -H "$AUTH_HEADER" -d '"PRESIDENT"' | python3 -m json.tool

  echo "  Adding Michael as TREASURER of Entrepreneurship Hub..."
  curl -s -X POST "$BASE_URL/api/clubs/${CLUB_IDS[3]}/members/${STUDENT_IDS[2]}" \
    -H "Content-Type: application/json" -H "$AUTH_HEADER" -d '"TREASURER"' | python3 -m json.tool

  # Photography: Emily=PRESIDENT, Sarah=MEMBER, David=MEMBER
  echo "  Adding Emily as PRESIDENT of Photography Club..."
  curl -s -X POST "$BASE_URL/api/clubs/${CLUB_IDS[4]}/members/${STUDENT_IDS[3]}" \
    -H "Content-Type: application/json" -H "$AUTH_HEADER" -d '"PRESIDENT"' | python3 -m json.tool

  echo "  Adding Sarah as MEMBER of Photography Club..."
  curl -s -X POST "$BASE_URL/api/clubs/${CLUB_IDS[4]}/members/${STUDENT_IDS[1]}" \
    -H "Content-Type: application/json" -H "$AUTH_HEADER" -d '"MEMBER"' | python3 -m json.tool

  echo "  Adding David as MEMBER of Photography Club..."
  curl -s -X POST "$BASE_URL/api/clubs/${CLUB_IDS[4]}/members/${STUDENT_IDS[4]}" \
    -H "Content-Type: application/json" -H "$AUTH_HEADER" -d '"MEMBER"' | python3 -m json.tool

else
  echo "  Not enough students or clubs created. Skipping member assignment."
fi

# ---- Step 9: GET members by club ID ----
echo ""
echo "=========================================="
echo ">>> Step 9: GET members of Tech Club..."
echo "=========================================="
if [ ${#CLUB_IDS[@]} -gt 0 ]; then
  curl -s -X GET "$BASE_URL/api/clubs/${CLUB_IDS[0]}/members" \
    -H "$AUTH_HEADER" | python3 -m json.tool
fi

# ---- Step 10: GET clubs by student ID ----
echo ""
echo "=========================================="
echo ">>> Step 10: GET clubs for student Alex..."
echo "=========================================="
if [ ${#STUDENT_IDS[@]} -gt 0 ]; then
  curl -s -X GET "$BASE_URL/api/student/${STUDENT_IDS[0]}/clubs" \
    -H "$AUTH_HEADER" | python3 -m json.tool
fi

# ---- Step 11: DELETE member (remove Michael from Tech Club) ----
echo ""
echo "=========================================="
echo ">>> Step 11: DELETE member (remove Michael from Tech Club)..."
echo "=========================================="
if [ ${#CLUB_IDS[@]} -gt 0 ] && [ ${#STUDENT_IDS[@]} -ge 3 ]; then
  curl -s -X DELETE "$BASE_URL/api/clubs/${CLUB_IDS[0]}/members/${STUDENT_IDS[2]}" \
    -H "$AUTH_HEADER" | python3 -m json.tool
fi

# ---- Step 12: Verify removal ----
echo ""
echo "=========================================="
echo ">>> Step 12: Verify - GET Tech Club members after removal..."
echo "=========================================="
if [ ${#CLUB_IDS[@]} -gt 0 ]; then
  curl -s -X GET "$BASE_URL/api/clubs/${CLUB_IDS[0]}/members" \
    -H "$AUTH_HEADER" | python3 -m json.tool
fi

# ##############################################
# ========== EVENT MODULE SEEDING =============
# ##############################################

echo ""
echo "=========================================="
echo "       EVENT MODULE DATA SEEDING"
echo "=========================================="

# ---- Step 13: Create Club-Organized Events ----
echo ""
echo "=========================================="
echo ">>> Step 13: Creating club-organized events..."
echo "=========================================="

declare -a EVENT_IDS

# Compute future timestamps (30, 60, 90 days from now) using python3
START_1=$(python3 -c "from datetime import datetime, timedelta, timezone; print((datetime.now(timezone.utc) + timedelta(days=30)).strftime('%Y-%m-%dT%H:%M:%SZ'))")
END_1=$(python3 -c "from datetime import datetime, timedelta, timezone; print((datetime.now(timezone.utc) + timedelta(days=30, hours=3)).strftime('%Y-%m-%dT%H:%M:%SZ'))")

START_2=$(python3 -c "from datetime import datetime, timedelta, timezone; print((datetime.now(timezone.utc) + timedelta(days=45)).strftime('%Y-%m-%dT%H:%M:%SZ'))")
END_2=$(python3 -c "from datetime import datetime, timedelta, timezone; print((datetime.now(timezone.utc) + timedelta(days=45, hours=6)).strftime('%Y-%m-%dT%H:%M:%SZ'))")

START_3=$(python3 -c "from datetime import datetime, timedelta, timezone; print((datetime.now(timezone.utc) + timedelta(days=60)).strftime('%Y-%m-%dT%H:%M:%SZ'))")
END_3=$(python3 -c "from datetime import datetime, timedelta, timezone; print((datetime.now(timezone.utc) + timedelta(days=60, hours=2)).strftime('%Y-%m-%dT%H:%M:%SZ'))")

START_4=$(python3 -c "from datetime import datetime, timedelta, timezone; print((datetime.now(timezone.utc) + timedelta(days=14)).strftime('%Y-%m-%dT%H:%M:%SZ'))")
END_4=$(python3 -c "from datetime import datetime, timedelta, timezone; print((datetime.now(timezone.utc) + timedelta(days=14, hours=4)).strftime('%Y-%m-%dT%H:%M:%SZ'))")

START_5=$(python3 -c "from datetime import datetime, timedelta, timezone; print((datetime.now(timezone.utc) + timedelta(days=21)).strftime('%Y-%m-%dT%H:%M:%SZ'))")
END_5=$(python3 -c "from datetime import datetime, timedelta, timezone; print((datetime.now(timezone.utc) + timedelta(days=21, hours=2)).strftime('%Y-%m-%dT%H:%M:%SZ'))")

if [ ${#CLUB_IDS[@]} -ge 5 ]; then

  # Event 1: Tech Club – AI/ML Workshop (WORKSHOP)
  echo ""
  echo "  Creating event: AI & Machine Learning Workshop (Tech Club)..."
  RESPONSE=$(curl -s -X POST "$BASE_URL/api/events/createEvent" \
    -H "Content-Type: application/json" \
    -H "$AUTH_HEADER" \
    -d "{\"title\":\"AI & Machine Learning Workshop\",\"description\":\"Dive into the fundamentals of artificial intelligence and machine learning. Hands-on session with Python, TensorFlow, and real-world datasets.\",\"coverImageUrl\":\"https://images.unsplash.com/photo-1677442136019-21780ecad995?w=800\",\"location\":\"Engineering Building, Room 301\",\"startTime\":\"$START_1\",\"endTime\":\"$END_1\",\"studentClubOrganizer\":{\"id\":\"${CLUB_IDS[0]}\"},\"category\":\"WORKSHOP\",\"capacity\":50,\"currentAttendees\":0,\"status\":\"UPCOMING\"}")
  echo "  Response: $RESPONSE"
  EID=$(echo "$RESPONSE" | python3 -c "import sys, json; print(json.load(sys.stdin)['data']['id'])" 2>/dev/null)
  if [ -n "$EID" ]; then
    EVENT_IDS+=("$EID")
    echo "  Event ID: $EID"
  else
    echo "  WARNING: Could not extract event ID"
  fi

  # Event 2: Robotics Club – RoboWars Competition (SOCIAL)
  echo ""
  echo "  Creating event: RoboWars Campus Competition (Robotics Society)..."
  RESPONSE=$(curl -s -X POST "$BASE_URL/api/events/createEvent" \
    -H "Content-Type: application/json" \
    -H "$AUTH_HEADER" \
    -d "{\"title\":\"RoboWars Campus Competition\",\"description\":\"Build, program, and battle your robots! Teams of 3-4 compete in an arena-style tournament with prizes for the top three.\",\"coverImageUrl\":\"https://images.unsplash.com/photo-1561557944-6e7860d1a7eb?w=800\",\"location\":\"Sports Hall B\",\"startTime\":\"$START_2\",\"endTime\":\"$END_2\",\"studentClubOrganizer\":{\"id\":\"${CLUB_IDS[1]}\"},\"category\":\"SOCIAL\",\"capacity\":80,\"currentAttendees\":0,\"status\":\"UPCOMING\"}")
  echo "  Response: $RESPONSE"
  EID=$(echo "$RESPONSE" | python3 -c "import sys, json; print(json.load(sys.stdin)['data']['id'])" 2>/dev/null)
  if [ -n "$EID" ]; then
    EVENT_IDS+=("$EID")
    echo "  Event ID: $EID"
  else
    echo "  WARNING: Could not extract event ID"
  fi

  # Event 3: Debate Club – Model UN Simulation (ACADEMIC)
  echo ""
  echo "  Creating event: Model United Nations Simulation (Debate Club)..."
  RESPONSE=$(curl -s -X POST "$BASE_URL/api/events/createEvent" \
    -H "Content-Type: application/json" \
    -H "$AUTH_HEADER" \
    -d "{\"title\":\"Model United Nations Simulation\",\"description\":\"Represent a country and debate global issues in a realistic UN General Assembly format. Improve diplomacy, public speaking, and critical thinking.\",\"coverImageUrl\":\"https://images.unsplash.com/photo-1524178232363-1fb2b075b655?w=800\",\"location\":\"Conference Center, Main Hall\",\"startTime\":\"$START_3\",\"endTime\":\"$END_3\",\"studentClubOrganizer\":{\"id\":\"${CLUB_IDS[2]}\"},\"category\":\"ACADEMIC\",\"capacity\":120,\"currentAttendees\":0,\"status\":\"UPCOMING\"}")
  echo "  Response: $RESPONSE"
  EID=$(echo "$RESPONSE" | python3 -c "import sys, json; print(json.load(sys.stdin)['data']['id'])" 2>/dev/null)
  if [ -n "$EID" ]; then
    EVENT_IDS+=("$EID")
    echo "  Event ID: $EID"
  else
    echo "  WARNING: Could not extract event ID"
  fi

  # Event 4: Entrepreneurship Hub – Startup Pitch Night (SOCIAL)
  echo ""
  echo "  Creating event: Startup Pitch Night (Entrepreneurship Hub)..."
  RESPONSE=$(curl -s -X POST "$BASE_URL/api/events/createEvent" \
    -H "Content-Type: application/json" \
    -H "$AUTH_HEADER" \
    -d "{\"title\":\"Startup Pitch Night\",\"description\":\"Present your startup idea to a panel of investors and mentors. Get feedback, make connections, and compete for seed funding prizes.\",\"coverImageUrl\":\"https://images.unsplash.com/photo-1559136555-9303baea8ebd?w=800\",\"location\":\"Business School Auditorium\",\"startTime\":\"$START_4\",\"endTime\":\"$END_4\",\"studentClubOrganizer\":{\"id\":\"${CLUB_IDS[3]}\"},\"category\":\"SOCIAL\",\"capacity\":100,\"currentAttendees\":0,\"status\":\"UPCOMING\"}")
  echo "  Response: $RESPONSE"
  EID=$(echo "$RESPONSE" | python3 -c "import sys, json; print(json.load(sys.stdin)['data']['id'])" 2>/dev/null)
  if [ -n "$EID" ]; then
    EVENT_IDS+=("$EID")
    echo "  Event ID: $EID"
  else
    echo "  WARNING: Could not extract event ID"
  fi

  # Event 5: Photography Club – Campus Photo Walk (SOCIAL)
  echo ""
  echo "  Creating event: Golden Hour Campus Photo Walk (Photography Club)..."
  RESPONSE=$(curl -s -X POST "$BASE_URL/api/events/createEvent" \
    -H "Content-Type: application/json" \
    -H "$AUTH_HEADER" \
    -d "{\"title\":\"Golden Hour Campus Photo Walk\",\"description\":\"Explore the most photogenic spots on campus during golden hour. Bring your camera or phone – tips on composition and lighting provided by club mentors.\",\"coverImageUrl\":\"https://images.unsplash.com/photo-1452587925148-ce544e77e70d?w=800\",\"location\":\"Meeting Point: Main Library Entrance\",\"startTime\":\"$START_5\",\"endTime\":\"$END_5\",\"studentClubOrganizer\":{\"id\":\"${CLUB_IDS[4]}\"},\"category\":\"SOCIAL\",\"capacity\":30,\"currentAttendees\":0,\"status\":\"UPCOMING\"}")
  echo "  Response: $RESPONSE"
  EID=$(echo "$RESPONSE" | python3 -c "import sys, json; print(json.load(sys.stdin)['data']['id'])" 2>/dev/null)
  if [ -n "$EID" ]; then
    EVENT_IDS+=("$EID")
    echo "  Event ID: $EID"
  else
    echo "  WARNING: Could not extract event ID"
  fi

else
  echo "  Not enough clubs created. Skipping club event creation."
fi

echo ""
echo "Created ${#EVENT_IDS[@]} club-organized events."

# ---- Step 14: Create Department-Organized Events ----
echo ""
echo "=========================================="
echo ">>> Step 14: Creating department-organized events..."
echo "=========================================="

declare -a DEPT_EVENT_IDS

START_D1=$(python3 -c "from datetime import datetime, timedelta, timezone; print((datetime.now(timezone.utc) + timedelta(days=10)).strftime('%Y-%m-%dT%H:%M:%SZ'))")
END_D1=$(python3 -c "from datetime import datetime, timedelta, timezone; print((datetime.now(timezone.utc) + timedelta(days=10, hours=2)).strftime('%Y-%m-%dT%H:%M:%SZ'))")

START_D2=$(python3 -c "from datetime import datetime, timedelta, timezone; print((datetime.now(timezone.utc) + timedelta(days=20)).strftime('%Y-%m-%dT%H:%M:%SZ'))")
END_D2=$(python3 -c "from datetime import datetime, timedelta, timezone; print((datetime.now(timezone.utc) + timedelta(days=20, hours=5)).strftime('%Y-%m-%dT%H:%M:%SZ'))")

START_D3=$(python3 -c "from datetime import datetime, timedelta, timezone; print((datetime.now(timezone.utc) + timedelta(days=35)).strftime('%Y-%m-%dT%H:%M:%SZ'))")
END_D3=$(python3 -c "from datetime import datetime, timedelta, timezone; print((datetime.now(timezone.utc) + timedelta(days=35, hours=1, minutes=30)).strftime('%Y-%m-%dT%H:%M:%SZ'))")

# Dept Event 1: COMPUTER_ENGINEERING – Guest Lecture
echo ""
echo "  Creating event: Guest Lecture on Quantum Computing (Computer Engineering)..."
RESPONSE=$(curl -s -X POST "$BASE_URL/api/events/createEvent" \
  -H "Content-Type: application/json" \
  -H "$AUTH_HEADER" \
  -d "{\"title\":\"Guest Lecture: Quantum Computing Frontiers\",\"description\":\"Join Prof. Dr. Sarah Chen from MIT for a deep dive into quantum algorithms, error correction, and the future of quantum hardware.\",\"coverImageUrl\":\"https://images.unsplash.com/photo-1635070041078-e363dbe005cb?w=800\",\"location\":\"Engineering Faculty, Amphitheater A\",\"startTime\":\"$START_D1\",\"endTime\":\"$END_D1\",\"departmentOrganizer\":\"COMPUTER_ENGINEERING\",\"category\":\"ACADEMIC\",\"capacity\":200,\"currentAttendees\":0,\"status\":\"UPCOMING\"}")
echo "  Response: $RESPONSE"
EID=$(echo "$RESPONSE" | python3 -c "import sys, json; print(json.load(sys.stdin)['data']['id'])" 2>/dev/null)
if [ -n "$EID" ]; then
  DEPT_EVENT_IDS+=("$EID")
  echo "  Event ID: $EID"
else
  echo "  WARNING: Could not extract event ID"
fi

# Dept Event 2: PHYSICS – Lab Open Day
echo ""
echo "  Creating event: Physics Lab Open Day (Physics Department)..."
RESPONSE=$(curl -s -X POST "$BASE_URL/api/events/createEvent" \
  -H "Content-Type: application/json" \
  -H "$AUTH_HEADER" \
  -d "{\"title\":\"Physics Lab Open Day\",\"description\":\"Tour the advanced physics laboratories, see live experiments in optics and particle detection, and meet the research teams.\",\"coverImageUrl\":\"https://images.unsplash.com/photo-1532094349884-543bc11b234d?w=800\",\"location\":\"Science Building, Floor 2\",\"startTime\":\"$START_D2\",\"endTime\":\"$END_D2\",\"departmentOrganizer\":\"PHYSICS\",\"category\":\"ACADEMIC\",\"capacity\":60,\"currentAttendees\":0,\"status\":\"UPCOMING\"}")
echo "  Response: $RESPONSE"
EID=$(echo "$RESPONSE" | python3 -c "import sys, json; print(json.load(sys.stdin)['data']['id'])" 2>/dev/null)
if [ -n "$EID" ]; then
  DEPT_EVENT_IDS+=("$EID")
  echo "  Event ID: $EID"
else
  echo "  WARNING: Could not extract event ID"
fi

# Dept Event 3: BUSINESS_ADMINISTRATION – Career Fair
echo ""
echo "  Creating event: Annual Career Fair (Business Administration)..."
RESPONSE=$(curl -s -X POST "$BASE_URL/api/events/createEvent" \
  -H "Content-Type: application/json" \
  -H "$AUTH_HEADER" \
  -d "{\"title\":\"Annual Business Career Fair\",\"description\":\"Meet recruiters from top companies including consulting, finance, and tech. Bring your resume and dress professionally.\",\"coverImageUrl\":\"https://images.unsplash.com/photo-1540575467063-178a50c2df87?w=800\",\"location\":\"Student Center, Grand Ballroom\",\"startTime\":\"$START_D3\",\"endTime\":\"$END_D3\",\"departmentOrganizer\":\"BUSINESS_ADMINISTRATION\",\"category\":\"SOCIAL\",\"capacity\":300,\"currentAttendees\":0,\"status\":\"UPCOMING\"}")
echo "  Response: $RESPONSE"
EID=$(echo "$RESPONSE" | python3 -c "import sys, json; print(json.load(sys.stdin)['data']['id'])" 2>/dev/null)
if [ -n "$EID" ]; then
  DEPT_EVENT_IDS+=("$EID")
  echo "  Event ID: $EID"
else
  echo "  WARNING: Could not extract event ID"
fi

echo ""
echo "Created ${#DEPT_EVENT_IDS[@]} department-organized events."

# ---- Step 15: GET event by ID ----
echo ""
echo "=========================================="
echo ">>> Step 15: GET event by ID (first club event)..."
echo "=========================================="
if [ ${#EVENT_IDS[@]} -gt 0 ]; then
  curl -s -X GET "$BASE_URL/api/events/getEvent?eventId=${EVENT_IDS[0]}" \
    -H "$AUTH_HEADER" | python3 -m json.tool
fi

# ---- Step 16: GET upcoming events (paginated) ----
echo ""
echo "=========================================="
echo ">>> Step 16: GET upcoming events (page 0, size 10)..."
echo "=========================================="
curl -s -X GET "$BASE_URL/api/events/getUpcomingEvents?pageNumber=0&pageSize=10" \
  -H "$AUTH_HEADER" | python3 -m json.tool

# ---- Step 17: GET events by club ID ----
echo ""
echo "=========================================="
echo ">>> Step 17: GET events for Tech Club..."
echo "=========================================="
if [ ${#CLUB_IDS[@]} -gt 0 ]; then
  curl -s -X GET "$BASE_URL/api/events/getAllClubEvents?clubId=${CLUB_IDS[0]}&pageNumber=0&pageSize=10" \
    -H "$AUTH_HEADER" | python3 -m json.tool
fi

# ---- Step 18: GET events by department ----
echo ""
echo "=========================================="
echo ">>> Step 18: GET events for COMPUTER_ENGINEERING department..."
echo "=========================================="
curl -s -X GET "$BASE_URL/api/events/getAllDepartmentEvents?department=COMPUTER_ENGINEERING&pageNumber=0&pageSize=10" \
  -H "$AUTH_HEADER" | python3 -m json.tool

# ---- Step 19: Register students for events ----
echo ""
echo "=========================================="
echo ">>> Step 19: Registering students for events..."
echo "=========================================="

declare -a REGISTRATION_IDS

if [ ${#STUDENT_IDS[@]} -ge 5 ] && [ ${#EVENT_IDS[@]} -ge 5 ]; then

  # Register Alex, Sarah, Michael for AI Workshop (Event 1)
  echo "  Registering Alex for AI & ML Workshop..."
  RESPONSE=$(curl -s -X POST "$BASE_URL/api/events/registerToEvent?eventId=${EVENT_IDS[0]}&studentId=${STUDENT_IDS[0]}" \
    -H "$AUTH_HEADER")
  echo "  Response: $RESPONSE"
  RID=$(echo "$RESPONSE" | python3 -c "import sys, json; print(json.load(sys.stdin)['data']['id'])" 2>/dev/null)
  [ -n "$RID" ] && REGISTRATION_IDS+=("$RID") && echo "  Registration ID: $RID"

  echo "  Registering Sarah for AI & ML Workshop..."
  RESPONSE=$(curl -s -X POST "$BASE_URL/api/events/registerToEvent?eventId=${EVENT_IDS[0]}&studentId=${STUDENT_IDS[1]}" \
    -H "$AUTH_HEADER")
  echo "  Response: $RESPONSE"
  RID=$(echo "$RESPONSE" | python3 -c "import sys, json; print(json.load(sys.stdin)['data']['id'])" 2>/dev/null)
  [ -n "$RID" ] && REGISTRATION_IDS+=("$RID") && echo "  Registration ID: $RID"

  echo "  Registering Michael for AI & ML Workshop..."
  RESPONSE=$(curl -s -X POST "$BASE_URL/api/events/registerToEvent?eventId=${EVENT_IDS[0]}&studentId=${STUDENT_IDS[2]}" \
    -H "$AUTH_HEADER")
  echo "  Response: $RESPONSE"
  RID=$(echo "$RESPONSE" | python3 -c "import sys, json; print(json.load(sys.stdin)['data']['id'])" 2>/dev/null)
  [ -n "$RID" ] && REGISTRATION_IDS+=("$RID") && echo "  Registration ID: $RID"

  # Register Emily, David for RoboWars (Event 2)
  echo "  Registering Emily for RoboWars Competition..."
  RESPONSE=$(curl -s -X POST "$BASE_URL/api/events/registerToEvent?eventId=${EVENT_IDS[1]}&studentId=${STUDENT_IDS[3]}" \
    -H "$AUTH_HEADER")
  echo "  Response: $RESPONSE"
  RID=$(echo "$RESPONSE" | python3 -c "import sys, json; print(json.load(sys.stdin)['data']['id'])" 2>/dev/null)
  [ -n "$RID" ] && REGISTRATION_IDS+=("$RID") && echo "  Registration ID: $RID"

  echo "  Registering David for RoboWars Competition..."
  RESPONSE=$(curl -s -X POST "$BASE_URL/api/events/registerToEvent?eventId=${EVENT_IDS[1]}&studentId=${STUDENT_IDS[4]}" \
    -H "$AUTH_HEADER")
  echo "  Response: $RESPONSE"
  RID=$(echo "$RESPONSE" | python3 -c "import sys, json; print(json.load(sys.stdin)['data']['id'])" 2>/dev/null)
  [ -n "$RID" ] && REGISTRATION_IDS+=("$RID") && echo "  Registration ID: $RID"

  # Register Alex, Emily for Model UN (Event 3)
  echo "  Registering Alex for Model UN Simulation..."
  RESPONSE=$(curl -s -X POST "$BASE_URL/api/events/registerToEvent?eventId=${EVENT_IDS[2]}&studentId=${STUDENT_IDS[0]}" \
    -H "$AUTH_HEADER")
  echo "  Response: $RESPONSE"
  RID=$(echo "$RESPONSE" | python3 -c "import sys, json; print(json.load(sys.stdin)['data']['id'])" 2>/dev/null)
  [ -n "$RID" ] && REGISTRATION_IDS+=("$RID") && echo "  Registration ID: $RID"

  echo "  Registering Emily for Model UN Simulation..."
  RESPONSE=$(curl -s -X POST "$BASE_URL/api/events/registerToEvent?eventId=${EVENT_IDS[2]}&studentId=${STUDENT_IDS[3]}" \
    -H "$AUTH_HEADER")
  echo "  Response: $RESPONSE"
  RID=$(echo "$RESPONSE" | python3 -c "import sys, json; print(json.load(sys.stdin)['data']['id'])" 2>/dev/null)
  [ -n "$RID" ] && REGISTRATION_IDS+=("$RID") && echo "  Registration ID: $RID"

  # Register David, Michael for Startup Pitch Night (Event 4)
  echo "  Registering David for Startup Pitch Night..."
  RESPONSE=$(curl -s -X POST "$BASE_URL/api/events/registerToEvent?eventId=${EVENT_IDS[3]}&studentId=${STUDENT_IDS[4]}" \
    -H "$AUTH_HEADER")
  echo "  Response: $RESPONSE"
  RID=$(echo "$RESPONSE" | python3 -c "import sys, json; print(json.load(sys.stdin)['data']['id'])" 2>/dev/null)
  [ -n "$RID" ] && REGISTRATION_IDS+=("$RID") && echo "  Registration ID: $RID"

  echo "  Registering Michael for Startup Pitch Night..."
  RESPONSE=$(curl -s -X POST "$BASE_URL/api/events/registerToEvent?eventId=${EVENT_IDS[3]}&studentId=${STUDENT_IDS[2]}" \
    -H "$AUTH_HEADER")
  echo "  Response: $RESPONSE"
  RID=$(echo "$RESPONSE" | python3 -c "import sys, json; print(json.load(sys.stdin)['data']['id'])" 2>/dev/null)
  [ -n "$RID" ] && REGISTRATION_IDS+=("$RID") && echo "  Registration ID: $RID"

  # Register Sarah, Emily, David for Photo Walk (Event 5)
  echo "  Registering Sarah for Photo Walk..."
  RESPONSE=$(curl -s -X POST "$BASE_URL/api/events/registerToEvent?eventId=${EVENT_IDS[4]}&studentId=${STUDENT_IDS[1]}" \
    -H "$AUTH_HEADER")
  echo "  Response: $RESPONSE"
  RID=$(echo "$RESPONSE" | python3 -c "import sys, json; print(json.load(sys.stdin)['data']['id'])" 2>/dev/null)
  [ -n "$RID" ] && REGISTRATION_IDS+=("$RID") && echo "  Registration ID: $RID"

  echo "  Registering Emily for Photo Walk..."
  RESPONSE=$(curl -s -X POST "$BASE_URL/api/events/registerToEvent?eventId=${EVENT_IDS[4]}&studentId=${STUDENT_IDS[3]}" \
    -H "$AUTH_HEADER")
  echo "  Response: $RESPONSE"
  RID=$(echo "$RESPONSE" | python3 -c "import sys, json; print(json.load(sys.stdin)['data']['id'])" 2>/dev/null)
  [ -n "$RID" ] && REGISTRATION_IDS+=("$RID") && echo "  Registration ID: $RID"

  echo "  Registering David for Photo Walk..."
  RESPONSE=$(curl -s -X POST "$BASE_URL/api/events/registerToEvent?eventId=${EVENT_IDS[4]}&studentId=${STUDENT_IDS[4]}" \
    -H "$AUTH_HEADER")
  echo "  Response: $RESPONSE"
  RID=$(echo "$RESPONSE" | python3 -c "import sys, json; print(json.load(sys.stdin)['data']['id'])" 2>/dev/null)
  [ -n "$RID" ] && REGISTRATION_IDS+=("$RID") && echo "  Registration ID: $RID"

else
  echo "  Not enough students or events created. Skipping event registration."
fi

echo ""
echo "Created ${#REGISTRATION_IDS[@]} event registrations."

# ---- Step 20: Mark attendance for some registrations ----
echo ""
echo "=========================================="
echo ">>> Step 20: Marking attendance for registrations..."
echo "=========================================="

if [ ${#REGISTRATION_IDS[@]} -ge 3 ]; then
  # Mark attendance for first 3 registrations (Alex, Sarah, Michael at AI Workshop)
  echo "  Marking attendance for registration: ${REGISTRATION_IDS[0]}..."
  curl -s -X PUT "$BASE_URL/api/events/markAttendance?eventRegistrationId=${REGISTRATION_IDS[0]}" \
    -H "$AUTH_HEADER" | python3 -m json.tool

  echo "  Marking attendance for registration: ${REGISTRATION_IDS[1]}..."
  curl -s -X PUT "$BASE_URL/api/events/markAttendance?eventRegistrationId=${REGISTRATION_IDS[1]}" \
    -H "$AUTH_HEADER" | python3 -m json.tool

  echo "  Marking attendance for registration: ${REGISTRATION_IDS[2]}..."
  curl -s -X PUT "$BASE_URL/api/events/markAttendance?eventRegistrationId=${REGISTRATION_IDS[2]}" \
    -H "$AUTH_HEADER" | python3 -m json.tool
else
  echo "  Not enough registrations to mark attendance."
fi

# ---- Step 21: Cancel a registration ----
echo ""
echo "=========================================="
echo ">>> Step 21: Cancelling a registration (David from Photo Walk)..."
echo "=========================================="

if [ ${#REGISTRATION_IDS[@]} -ge 12 ]; then
  # Last registration is David for Photo Walk (index 11)
  echo "  Cancelling registration: ${REGISTRATION_IDS[11]}..."
  curl -s -X PUT "$BASE_URL/api/events/cancelRegistration?eventRegistrationId=${REGISTRATION_IDS[11]}" \
    -H "$AUTH_HEADER" | python3 -m json.tool
else
  echo "  Registration ID not available for cancellation."
fi

# ---- Step 22: GET event attendees ----
echo ""
echo "=========================================="
echo ">>> Step 22: GET attendees of AI & ML Workshop..."
echo "=========================================="
if [ ${#EVENT_IDS[@]} -gt 0 ]; then
  curl -s -X GET "$BASE_URL/api/events/getEventAttendees?eventId=${EVENT_IDS[0]}&pageNumber=0&pageSize=10" \
    -H "$AUTH_HEADER" | python3 -m json.tool
fi

# ---- Step 23: UPDATE an event ----
echo ""
echo "=========================================="
echo ">>> Step 23: UPDATE event (AI & ML Workshop – increase capacity)..."
echo "=========================================="
if [ ${#EVENT_IDS[@]} -gt 0 ]; then
  RESPONSE=$(curl -s -X PUT "$BASE_URL/api/events/updateEvent" \
    -H "Content-Type: application/json" \
    -H "$AUTH_HEADER" \
    -d "{\"id\":\"${EVENT_IDS[0]}\",\"title\":\"AI & Machine Learning Workshop – Extended Edition\",\"description\":\"UPDATED: Now a full-day event! Covers neural networks, NLP, and computer vision with hands-on labs.\",\"capacity\":75}")
  echo "$RESPONSE" | python3 -m json.tool
fi

# ---- Step 24: DELETE an event ----
echo ""
echo "=========================================="
echo ">>> Step 24: DELETE event (Photo Walk)..."
echo "=========================================="
if [ ${#EVENT_IDS[@]} -ge 5 ]; then
  curl -s -X DELETE "$BASE_URL/api/events/deleteEvent?eventId=${EVENT_IDS[4]}" \
    -H "$AUTH_HEADER" | python3 -m json.tool
fi

# ---- Step 25: Verify – GET upcoming events after changes ----
echo ""
echo "=========================================="
echo ">>> Step 25: Verify – GET upcoming events after all changes..."
echo "=========================================="
curl -s -X GET "$BASE_URL/api/events/getUpcomingEvents?pageNumber=0&pageSize=10" \
  -H "$AUTH_HEADER" | python3 -m json.tool

echo ""
echo "=========================================="
echo " Seeding Complete!"
echo "=========================================="
echo ""
echo "Summary:"
echo "  - Students registered & created: ${#STUDENT_IDS[@]}"
echo "  - Clubs created: ${#CLUB_IDS[@]}"
echo "  - Club events created: ${#EVENT_IDS[@]}"
echo "  - Department events created: ${#DEPT_EVENT_IDS[@]}"
echo "  - Event registrations created: ${#REGISTRATION_IDS[@]}"
echo "  - All Club CRUD + membership endpoints tested"
echo "  - All Event CRUD + registration + attendance endpoints tested"
echo "=========================================="
