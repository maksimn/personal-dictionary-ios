# Define output file. Change "${PROJECT_DIR}/${PROJECT_NAME}Tests" to your test's root source folder, if it's not the default name.
OUTPUT_FILE="./Tests/GeneratedMocks.swift"
echo "Generated Mocks File = ${OUTPUT_FILE}"

# Define input directory. Change "${PROJECT_DIR}/${PROJECT_NAME}" to your project's root source folder, if it's not the default name.
CORE_MODULE_INPUT_DIR="../CoreModule/Source"
INPUT_DIR="./Source"
echo "Mocks Input Directory = ${INPUT_DIR}"
echo "CoreModule Mocks Input Directory = ${CORE_MODULE_INPUT_DIR}"

# Generate mock files, include as many input files as you'd like to create mocks for.
"../../Pods/Cuckoo/run" generate --testable PersonalDictionary,CoreModule \
--output "${OUTPUT_FILE}" \
"${INPUT_DIR}/Repository/WordList/WordListRepository.swift" \
"${INPUT_DIR}/Repository/Lang/LangRepository.swift" \
"${CORE_MODULE_INPUT_DIR}/JsonCoder/JsonCoder.swift" \
"${CORE_MODULE_INPUT_DIR}/Logger/Logger.swift" \
"${CORE_MODULE_INPUT_DIR}/Networking/HttpClient.swift" 
# ... and so forth, the last line should never end with a backslash
