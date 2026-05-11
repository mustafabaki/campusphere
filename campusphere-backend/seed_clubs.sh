#!/bin/bash

# ==============================================
# CampuSphere - Student Club Data Seeder Script
# ==============================================

BASE_URL="http://localhost:8080"
echo "=========================================="
echo " CampuSphere Student Club Data Seeder"
echo "=========================================="

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

EMAILS=("ali.yilmaz@university.edu" "zeynep.kaya@university.edu" "mehmet.demir@university.edu" "elif.ozturk@university.edu" "can.arslan@university.edu")

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
  '{"name":"Ali","surname":"Yilmaz","email":"ali.yilmaz@university.edu","phone":"+905551234567","profilePictureURL":"https://i.pravatar.cc/150?img=1","department":"COMPUTER_ENGINEERING","socialLinks":[]}'
  '{"name":"Zeynep","surname":"Kaya","email":"zeynep.kaya@university.edu","phone":"+905552345678","profilePictureURL":"https://i.pravatar.cc/150?img=5","department":"ELECTRICAL_ENGINEERING","socialLinks":[]}'
  '{"name":"Mehmet","surname":"Demir","email":"mehmet.demir@university.edu","phone":"+905553456789","profilePictureURL":"https://i.pravatar.cc/150?img=3","department":"MATHEMATICS","socialLinks":[]}'
  '{"name":"Elif","surname":"Ozturk","email":"elif.ozturk@university.edu","phone":"+905554567890","profilePictureURL":"https://i.pravatar.cc/150?img=9","department":"PHYSICS","socialLinks":[]}'
  '{"name":"Can","surname":"Arslan","email":"can.arslan@university.edu","phone":"+905555678901","profilePictureURL":"https://i.pravatar.cc/150?img=7","department":"BUSINESS_ADMINISTRATION","socialLinks":[]}'
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

  # Tech Club: Ali=PRESIDENT, Zeynep=VICE_PRESIDENT, Mehmet=MEMBER
  echo "  Adding Ali as PRESIDENT of Tech Club..."
  curl -s -X POST "$BASE_URL/api/clubs/${CLUB_IDS[0]}/members/${STUDENT_IDS[0]}" \
    -H "Content-Type: application/json" -H "$AUTH_HEADER" -d '"PRESIDENT"' | python3 -m json.tool

  echo "  Adding Zeynep as VICE_PRESIDENT of Tech Club..."
  curl -s -X POST "$BASE_URL/api/clubs/${CLUB_IDS[0]}/members/${STUDENT_IDS[1]}" \
    -H "Content-Type: application/json" -H "$AUTH_HEADER" -d '"VICE_PRESIDENT"' | python3 -m json.tool

  echo "  Adding Mehmet as MEMBER of Tech Club..."
  curl -s -X POST "$BASE_URL/api/clubs/${CLUB_IDS[0]}/members/${STUDENT_IDS[2]}" \
    -H "Content-Type: application/json" -H "$AUTH_HEADER" -d '"MEMBER"' | python3 -m json.tool

  # Robotics: Zeynep=PRESIDENT, Can=SECRETARY
  echo "  Adding Zeynep as PRESIDENT of Robotics Society..."
  curl -s -X POST "$BASE_URL/api/clubs/${CLUB_IDS[1]}/members/${STUDENT_IDS[1]}" \
    -H "Content-Type: application/json" -H "$AUTH_HEADER" -d '"PRESIDENT"' | python3 -m json.tool

  echo "  Adding Can as SECRETARY of Robotics Society..."
  curl -s -X POST "$BASE_URL/api/clubs/${CLUB_IDS[1]}/members/${STUDENT_IDS[4]}" \
    -H "Content-Type: application/json" -H "$AUTH_HEADER" -d '"SECRETARY"' | python3 -m json.tool

  # Debate: Elif=PRESIDENT, Ali=MEMBER
  echo "  Adding Elif as PRESIDENT of Debate Club..."
  curl -s -X POST "$BASE_URL/api/clubs/${CLUB_IDS[2]}/members/${STUDENT_IDS[3]}" \
    -H "Content-Type: application/json" -H "$AUTH_HEADER" -d '"PRESIDENT"' | python3 -m json.tool

  echo "  Adding Ali as MEMBER of Debate Club..."
  curl -s -X POST "$BASE_URL/api/clubs/${CLUB_IDS[2]}/members/${STUDENT_IDS[0]}" \
    -H "Content-Type: application/json" -H "$AUTH_HEADER" -d '"MEMBER"' | python3 -m json.tool

  # Entrepreneurship: Can=PRESIDENT, Mehmet=TREASURER
  echo "  Adding Can as PRESIDENT of Entrepreneurship Hub..."
  curl -s -X POST "$BASE_URL/api/clubs/${CLUB_IDS[3]}/members/${STUDENT_IDS[4]}" \
    -H "Content-Type: application/json" -H "$AUTH_HEADER" -d '"PRESIDENT"' | python3 -m json.tool

  echo "  Adding Mehmet as TREASURER of Entrepreneurship Hub..."
  curl -s -X POST "$BASE_URL/api/clubs/${CLUB_IDS[3]}/members/${STUDENT_IDS[2]}" \
    -H "Content-Type: application/json" -H "$AUTH_HEADER" -d '"TREASURER"' | python3 -m json.tool

  # Photography: Elif=PRESIDENT, Zeynep=MEMBER, Can=MEMBER
  echo "  Adding Elif as PRESIDENT of Photography Club..."
  curl -s -X POST "$BASE_URL/api/clubs/${CLUB_IDS[4]}/members/${STUDENT_IDS[3]}" \
    -H "Content-Type: application/json" -H "$AUTH_HEADER" -d '"PRESIDENT"' | python3 -m json.tool

  echo "  Adding Zeynep as MEMBER of Photography Club..."
  curl -s -X POST "$BASE_URL/api/clubs/${CLUB_IDS[4]}/members/${STUDENT_IDS[1]}" \
    -H "Content-Type: application/json" -H "$AUTH_HEADER" -d '"MEMBER"' | python3 -m json.tool

  echo "  Adding Can as MEMBER of Photography Club..."
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
echo ">>> Step 10: GET clubs for student Ali..."
echo "=========================================="
if [ ${#STUDENT_IDS[@]} -gt 0 ]; then
  curl -s -X GET "$BASE_URL/api/student/${STUDENT_IDS[0]}/clubs" \
    -H "$AUTH_HEADER" | python3 -m json.tool
fi

# ---- Step 11: DELETE member (remove Mehmet from Tech Club) ----
echo ""
echo "=========================================="
echo ">>> Step 11: DELETE member (remove Mehmet from Tech Club)..."
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

echo ""
echo "=========================================="
echo " Seeding Complete!"
echo "=========================================="
echo ""
echo "Summary:"
echo "  - Students registered & created: ${#STUDENT_IDS[@]}"
echo "  - Clubs created: ${#CLUB_IDS[@]}"
echo "  - All CRUD + membership endpoints tested"
echo "=========================================="
