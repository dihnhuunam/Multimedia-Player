// Combines first name and last name into a full name
function getFullName(firstName, lastName) {
  return `${firstName.trim()} ${lastName.trim()}`.trim();
}

// Formats date of birth into YYYY-MM-DD format
function formatDateOfBirth(monthIndex, dayIndex, yearIndex, yearModel) {
  if (monthIndex === 0 || dayIndex === 0 || yearIndex === 0) {
    return ""; // Return empty string if any field is not selected
  }

  var month = monthIndex.toString().padStart(2, "0"); // Ensure two digits
  var day = dayIndex.toString().padStart(2, "0"); // Ensure two digits
  var year = yearModel[yearIndex]; // Get year from the yearComboBox model
  return `${year}-${month}-${day}`; // Format as YYYY-MM-DD
}
