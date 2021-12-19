# Define output file. Change "${PROJECT_DIR}/${PROJECT_NAME}Tests" to your test's root source folder, if it's not the default name.
OUTPUT_FILE="./Tests/GeneratedMocks.swift"
echo "Generated Mocks File = ${OUTPUT_FILE}"

# Define input directory. Change "${PROJECT_DIR}/${PROJECT_NAME}" to your project's root source folder, if it's not the default name.
INPUT_DIR="./Source"
echo "Mocks Input Directory = ${INPUT_DIR}"

# Generate mock files, include as many input files as you'd like to create mocks for.
"../../Pods/Cuckoo/run" generate --testable "PersonalDictionary" \
--output "${OUTPUT_FILE}" \
"${INPUT_DIR}/Repository/WordList/WordListRepository.swift"
# ... and so forth, the last line should never end with a backslash
