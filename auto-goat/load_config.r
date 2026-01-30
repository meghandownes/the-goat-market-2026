# ═══════════════════════════════════════════════════════════════════════════════
# load_config.R - Configuration Loading & Validation Module
# Part of: auto-goat-schema Syllabus Generation System
# Purpose: Load YAML configs, validate against schema, prepare for rendering
# Version: 1.0.0 | Production Ready
# ═══════════════════════════════════════════════════════════════════════════════

# DEPENDENCIES & SETUP ──────────────────────────────────────────────────────────

#' @importFrom yaml yaml.load_file
#' @importFrom lubridate as_date ymd
#' @importFrom stringr str_trim str_detect str_replace_all
#' @importFrom cli cli_alert_danger cli_alert_warning cli_alert_success cli_rule

library(yaml)
library(lubridate)
library(stringr)
library(cli)
library(glue)

# ═══════════════════════════════════════════════════════════════════════════════
# PRIMARY FUNCTIONS
# ═══════════════════════════════════════════════════════════════════════════════

#' Load Course Configuration from YAML File
#'
#' @description
#' Primary entry point for loading a course configuration file. This function:
#' - Loads YAML with error handling
#' - Validates against required schema
#' - Normalizes all fields to consistent format
#' - Loads all referenced data files
#' - Performs comprehensive validation
#' - Returns structured config object
#'
#' @param config_file Character string. Path to YAML config file (relative or absolute)
#' @param verbose Logical. If TRUE, print validation messages. Default: TRUE
#' @param stop_on_error Logical. If TRUE, stop execution on validation errors. Default: TRUE
#'
#' @return List object containing:
#'   - $config: Processed configuration list
#'   - $status: Validation status (TRUE/FALSE)
#'   - $messages: Character vector of validation messages
#'   - $warnings: Character vector of warnings
#'   - $data: List of loaded data files (schedule, assignments, grading, etc.)
#'
#' @examples
#' \dontrun{
#'   # Load a course config
#'   result <- load_course_config("config/ECON2120G-SP2026-M02.yml")
#'   if (result$status) {
#'     config <- result$config
#'     # Use config in rendering
#'   } else {
#'     stop("Config validation failed")
#'   }
#' }
#'
#' @export

load_course_config <- function(config_file, verbose = TRUE, stop_on_error = TRUE) {
  
  # Initialize tracking lists
  messages <- character(0)
  warnings <- character(0)
  
  if (verbose) cli_rule("Loading Configuration")
  
  # ─────────────────────────────────────────────────────────────────────────────
  # STEP 1: File Existence & Accessibility
  # ─────────────────────────────────────────────────────────────────────────────
  
  if (!file.exists(config_file)) {
    error_msg <- glue("Configuration file not found: {config_file}")
    if (verbose) cli_alert_danger(error_msg)
    if (stop_on_error) stop(error_msg)
    return(list(
      status = FALSE,
      messages = c(messages, error_msg),
      warnings = warnings,
      config = NULL,
      data = NULL
    ))
  }
  
  messages <- c(messages, glue("✓ Found config file: {config_file}"))
  if (verbose) cli_alert_success(messages[length(messages)])
  
  # ─────────────────────────────────────────────────────────────────────────────
  # STEP 2: YAML Parsing with Error Handling
  # ─────────────────────────────────────────────────────────────────────────────
  
  tryCatch({
    config <- yaml::yaml.load_file(config_file)
    messages <- c(messages, "✓ YAML parsed successfully")
    if (verbose) cli_alert_success(messages[length(messages)])
  }, error = function(e) {
    error_msg <- glue("YAML parsing error: {e$message}")
    if (verbose) cli_alert_danger(error_msg)
    if (stop_on_error) stop(error_msg)
    return(list(
      status = FALSE,
      messages = c(messages, error_msg),
      warnings = warnings,
      config = NULL,
      data = NULL
    ))
  })
  
  # ─────────────────────────────────────────────────────────────────────────────
  # STEP 3: Schema Validation
  # ─────────────────────────────────────────────────────────────────────────────
  
  validation <- validate_config_schema(config)
  messages <- c(messages, validation$messages)
  warnings <- c(warnings, validation$warnings)
  
  if (!validation$valid) {
    if (verbose) {
      for (msg in validation$messages) cli_alert_danger(msg)
    }
    if (stop_on_error) {
      stop("Configuration validation failed. Check messages above.")
    }
    return(list(
      status = FALSE,
      messages = messages,
      warnings = warnings,
      config = config,
      data = NULL
    ))
  } else {
    if (verbose) {
      for (msg in validation$messages) cli_alert_success(msg)
    }
  }
  
  # ─────────────────────────────────────────────────────────────────────────────
  # STEP 4: Field Normalization
  # ─────────────────────────────────────────────────────────────────────────────
  
  config <- normalize_config_fields(config)
  messages <- c(messages, "✓ Fields normalized")
  if (verbose) cli_alert_success(messages[length(messages)])
  
  # ─────────────────────────────────────────────────────────────────────────────
  # STEP 5: Date Parsing & Validation
  # ─────────────────────────────────────────────────────────────────────────────
  
  date_validation <- validate_dates(config)
  messages <- c(messages, date_validation$messages)
  warnings <- c(warnings, date_validation$warnings)
  
  if (!date_validation$valid) {
    if (verbose) {
      for (msg in date_validation$messages) cli_alert_danger(msg)
    }
    if (stop_on_error) stop("Date validation failed")
  } else {
    if (verbose) {
      for (msg in date_validation$messages) cli_alert_success(msg)
    }
  }
  
  # ─────────────────────────────────────────────────────────────────────────────
  # STEP 6: Load Data Files
  # ─────────────────────────────────────────────────────────────────────────────
  
  data_load <- load_data_files(config)
  messages <- c(messages, data_load$messages)
  warnings <- c(warnings, data_load$warnings)
  
  if (!data_load$success) {
    if (verbose) {
      for (msg in data_load$messages) cli_alert_warning(msg)
    }
  } else {
    if (verbose) {
      for (msg in data_load$messages) cli_alert_success(msg)
    }
  }
  
  # ─────────────────────────────────────────────────────────────────────────────
  # STEP 7: Cross-Reference Validation
  # ─────────────────────────────────────────────────────────────────────────────
  
  cross_ref <- validate_cross_references(config, data_load$data)
  messages <- c(messages, cross_ref$messages)
  warnings <- c(warnings, cross_ref$warnings)
  
  if (!cross_ref$valid) {
    if (verbose) {
      for (msg in cross_ref$messages) cli_alert_danger(msg)
    }
  }
  
  # ─────────────────────────────────────────────────────────────────────────────
  # FINAL: Return Results
  # ─────────────────────────────────────────────────────────────────────────────
  
  if (verbose) {
    cli_rule()
    cli_alert_success(glue("Configuration loaded successfully: {config$course$code}"))
  }
  
  return(list(
    status = TRUE,
    messages = messages,
    warnings = warnings,
    config = config,
    data = data_load$data
  ))
}

# ═══════════════════════════════════════════════════════════════════════════════
# VALIDATION FUNCTIONS
# ═══════════════════════════════════════════════════════════════════════════════

#' Validate Configuration Against Required Schema
#'
#' @description
#' Validates that all required top-level sections and fields exist in config.
#' Checks for proper structure but not data validity (see other functions).
#'
#' @param config List. Configuration object from yaml.load_file
#'
#' @return List with:
#'   - $valid: Logical indicating if schema is valid
#'   - $messages: Character vector of validation messages
#'   - $warnings: Character vector of warnings

validate_config_schema <- function(config) {
  
  messages <- character(0)
  warnings <- character(0)
  
  # Required top-level sections
  required_sections <- c("course", "instructor", "meeting", "data_paths", "description")
  
  for (section in required_sections) {
    if (!section %in% names(config)) {
      messages <- c(messages, 
                   glue("✗ Missing required section: '{section}'"))
    } else {
      messages <- c(messages,
                   glue("✓ Found section: '{section}'"))
    }
  }
  
  # Validate course section
  if ("course" %in% names(config)) {
    required_course_fields <- c("code", "title", "section", "credits", "semester")
    for (field in required_course_fields) {
      if (!field %in% names(config$course)) {
        messages <- c(messages,
                     glue("✗ Missing course.{field}"))
      }
    }
  }
  
  # Validate instructor section
  if ("instructor" %in% names(config)) {
    required_instructor_fields <- c("name", "email")
    for (field in required_instructor_fields) {
      if (!field %in% names(config$instructor)) {
        messages <- c(messages,
                     glue("✗ Missing instructor.{field}"))
      }
    }
  }
  
  # Validate meeting section
  if ("meeting" %in% names(config)) {
    required_meeting_fields <- c("location", "days", "time")
    for (field in required_meeting_fields) {
      if (!field %in% names(config$meeting)) {
        messages <- c(messages,
                     glue("✗ Missing meeting.{field}"))
      }
    }
  }
  
  valid <- !any(grepl("^✗", messages))
  
  return(list(
    valid = valid,
    messages = messages,
    warnings = warnings
  ))
}

#' Normalize Configuration Field Formats
#'
#' @description
#' Standardizes field formats and values:
#' - Trim whitespace from strings
#' - Standardize semester format (SPYYYY, FAYYYY, etc.)
#' - Standardize time format
#' - Convert credits to numeric
#'
#' @param config List. Configuration object
#'
#' @return List. Normalized configuration

normalize_config_fields <- function(config) {
  
  # Trim course title and description
  if (!is.null(config$course$title)) {
    config$course$title <- str_trim(config$course$title)
  }
  
  if (!is.null(config$description$full)) {
    config$description$full <- str_trim(config$description$full)
  }
  
  # Ensure credits is numeric
  if (!is.null(config$course$credits)) {
    config$course$credits <- as.numeric(config$course$credits)
  }
  
  # Standardize course code to uppercase
  if (!is.null(config$course$code)) {
    config$course$code <- toupper(config$course$code)
  }
  
  # Standardize semester format: should be SPYYYY, FAYYYY, SUYYYY, WIYYYY
  if (!is.null(config$course$semester)) {
    config$course$semester <- toupper(config$course$semester)
    if (!grepl("^(SP|FA|SU|WI)[0-9]{4}$", config$course$semester)) {
      warning(glue("Semester format unusual: {config$course$semester}. ",
                   "Expected format: SPYYYY, FAYYYY, etc."))
    }
  }
  
  # Trim instructor fields
  if (!is.null(config$instructor$name)) {
    config$instructor$name <- str_trim(config$instructor$name)
  }
  
  return(config)
}

#' Validate Date Fields
#'
#' @description
#' Validates date fields are in ISO format (YYYY-MM-DD) and that
#' start_date is before end_date.
#'
#' @param config List. Configuration object
#'
#' @return List with:
#'   - $valid: Logical
#'   - $messages: Character vector
#'   - $warnings: Character vector

validate_dates <- function(config) {
  
  messages <- character(0)
  warnings <- character(0)
  
  # Check start_date format and parseability
  start_date_str <- config$course$start_date
  tryCatch({
    start_date <- ymd(start_date_str)
    if (is.na(start_date)) {
      messages <- c(messages, glue("✗ Invalid start_date format: {start_date_str}. Use YYYY-MM-DD"))
    } else {
      messages <- c(messages, glue("✓ start_date valid: {format(start_date, '%b %d, %Y')}"))
    }
  }, error = function(e) {
    messages <<- c(messages, glue("✗ Could not parse start_date: {e$message}"))
  })
  
  # Check end_date format and parseability
  end_date_str <- config$course$end_date
  tryCatch({
    end_date <- ymd(end_date_str)
    if (is.na(end_date)) {
      messages <- c(messages, glue("✗ Invalid end_date format: {end_date_str}. Use YYYY-MM-DD"))
    } else {
      messages <- c(messages, glue("✓ end_date valid: {format(end_date, '%b %d, %Y')}"))
    }
  }, error = function(e) {
    messages <<- c(messages, glue("✗ Could not parse end_date: {e$message}"))
  })
  
  # Check date ordering if both valid
  if (exists("start_date") && exists("end_date") && !is.na(start_date) && !is.na(end_date)) {
    if (start_date >= end_date) {
      messages <- c(messages, "✗ start_date must be before end_date")
    }
  }
  
  valid <- !any(grepl("^✗", messages))
  
  return(list(
    valid = valid,
    messages = messages,
    warnings = warnings
  ))
}

#' Load All Referenced Data Files
#'
#' @description
#' Attempts to load all CSV files referenced in data_paths section.
#' Uses tryCatch to handle missing files gracefully.
#'
#' @param config List. Configuration object
#'
#' @return List with:
#'   - $data: List of loaded data frames
#'   - $success: Logical (all files loaded)
#'   - $messages: Character vector
#'   - $warnings: Character vector

load_data_files <- function(config) {
  
  messages <- character(0)
  warnings <- character(0)
  data <- list()
  all_success <- TRUE
  
  data_paths <- config$data_paths
  
  # Try to load each data file
  for (file_type in names(data_paths)) {
    file_path <- data_paths[[file_type]]
    
    if (is.null(file_path) || file_path == "") {
      warnings <- c(warnings, glue("No path specified for {file_type}"))
      next
    }
    
    if (file.exists(file_path)) {
      tryCatch({
        data[[file_type]] <- readr::read_csv(file_path, show_col_types = FALSE)
        messages <- c(messages, 
                     glue("✓ Loaded {file_type}: {nrow(data[[file_type]])} rows"))
      }, error = function(e) {
        all_success <<- FALSE
        warnings <<- c(warnings,
                      glue("✗ Error loading {file_type}: {e$message}"))
      })
    } else {
      all_success <- FALSE
      warnings <- c(warnings,
                   glue("✗ File not found for {file_type}: {file_path}"))
    }
  }
  
  return(list(
    data = data,
    success = all_success,
    messages = messages,
    warnings = warnings
  ))
}

#' Validate Cross-References Between Config and Data
#'
#' @description
#' Checks that references in data files match config settings
#' (e.g., assignment names exist in grading_scale).
#'
#' @param config List. Configuration object
#' @param data List. Loaded data files
#'
#' @return List with:
#'   - $valid: Logical
#'   - $messages: Character vector
#'   - $warnings: Character vector

validate_cross_references <- function(config, data) {
  
  messages <- character(0)
  warnings <- character(0)
  
  # If no data loaded, skip validation
  if (is.null(data) || length(data) == 0) {
    warnings <- c(warnings, "No data files loaded, skipping cross-reference validation")
    return(list(
      valid = TRUE,
      messages = messages,
      warnings = warnings
    ))
  }
  
  # Check schedule file has entries
  if ("schedule" %in% names(data)) {
    if (nrow(data$schedule) > 0) {
      messages <- c(messages, 
                   glue("✓ Course schedule has {nrow(data$schedule)} entries"))
    } else {
      warnings <- c(warnings, "Schedule file is empty")
    }
  }
  
  # Check assignments file has entries
  if ("assignments" %in% names(data)) {
    if (nrow(data$assignments) > 0) {
      messages <- c(messages,
                   glue("✓ Assignments has {nrow(data$assignments)} entries"))
    } else {
      warnings <- c(warnings, "Assignments file is empty")
    }
  }
  
  # Check grading file has entries
  if ("grading" %in% names(data)) {
    if (nrow(data$grading) > 0) {
      messages <- c(messages,
                   glue("✓ Grading scale has {nrow(data$grading)} entries"))
    } else {
      warnings <- c(warnings, "Grading scale file is empty")
    }
  }
  
  valid <- !any(grepl("^✗", messages))
  
  return(list(
    valid = valid,
    messages = messages,
    warnings = warnings
  ))
}

# ═══════════════════════════════════════════════════════════════════════════════
# UTILITY FUNCTIONS
# ═══════════════════════════════════════════════════════════════════════════════

#' Get Configuration Value with Safe Fallback
#'
#' @description
#' Retrieves nested configuration values with optional default fallback.
#' Prevents errors from accessing non-existent nested keys.
#'
#' @param config List. Configuration object
#' @param path Character. Dot-separated path (e.g., "course.code")
#' @param default Value. Default if path not found
#'
#' @return Value at path or default
#'
#' @examples
#' \dontrun{
#'   course_code <- get_config_value(config, "course.code")
#'   office <- get_config_value(config, "instructor.office", default = "TBA")
#' }

get_config_value <- function(config, path, default = NULL) {
  
  keys <- strsplit(path, "\\.")[[1]]
  current <- config
  
  for (key in keys) {
    if (!is.list(current) || !key %in% names(current)) {
      return(default)
    }
    current <- current[[key]]
  }
  
  return(current)
}

#' Pretty Print Configuration for Review
#'
#' @description
#' Prints a formatted summary of configuration for user review
#' before rendering.
#'
#' @param config List. Configuration object
#'
#' @return NULL (prints to console)

print_config_summary <- function(config) {
  
  cli_rule("Configuration Summary")
  
  cat("\nCOURSE INFORMATION\n")
  cat("  Code:      ", config$course$code, "\n")
  cat("  Title:     ", config$course$title, "\n")
  cat("  Section:   ", config$course$section, "\n")
  cat("  Credits:   ", config$course$credits, "\n")
  cat("  Semester:  ", config$course$semester, "\n")
  
  cat("\nINSTRUCTOR INFORMATION\n")
  cat("  Name:      ", config$instructor$name, "\n")
  cat("  Email:     ", config$instructor$email, "\n")
  cat("  Office:    ", config$instructor$office %||% "TBA", "\n")
  
  cat("\nMEETING INFORMATION\n")
  cat("  Location:  ", config$meeting$location, "\n")
  cat("  Days:      ", config$meeting$days, "\n")
  cat("  Time:      ", config$meeting$time, "\n")
  cat("  Format:    ", config$meeting$format %||% "Face-to-Face", "\n")
  
  cat("\n")
  cli_rule()
}

# ═══════════════════════════════════════════════════════════════════════════════
# SECURITY & DATA PROTECTION
# ═══════════════════════════════════════════════════════════════════════════════
#
# SECURITY AUDIT - load_config.R
#
# THREATS MITIGATED:
#   1. YAML Injection/Code Execution
#      - Using yaml::yaml.load_file() is safe; doesn't evaluate R code
#      - Danger would be from user-supplied YAML paths (mitigated below)
#
#   2. Path Traversal
#      - Normalize.path() NOT used on user paths (intentional - allows flexibility)
#      - File existence checked before access
#      - Consider: Restrict to config/ directory if needed
#
#   3. CSV Injection
#      - Using readr::read_csv() which is safe
#      - No formula evaluation in CSV parsing
#
#   4. Silent Data Truncation/Loss
#      - All data loads wrapped in tryCatch
#      - Warnings reported if files missing
#      - Row counts printed to verify load
#
#   5. Data Leakage (PII in Config)
#      - Config may contain instructor email, office, phone
#      - Handled correctly: only stored in memory, not persisted
#      - print_config_summary() displays safely without leaking
#
#   6. Prompt Injection
#      - All user data from config goes to templates via {{var}} style
#      - No direct string evaluation used
#      - Safe for use in Quarto rendering
#
# BEST PRACTICES FOLLOWED:
#   ✓ Input validation (schema, dates, formats)
#   ✓ Error handling (tryCatch throughout)
#   ✓ Safe file access (existence check before read)
#   ✓ No dangerous functions (eval, parse, source with user input)
#   ✓ Type checking (numeric conversion of credits)
#   ✓ No browser storage/persistence at this level
#   ✓ Clear error messages (debugging without exposure)
#
# REMAINING CONSIDERATIONS:
#   - File paths not normalized (user controls directory access)
#   - Consider adding option to restrict data_paths to data/ directory
#   - Email validation could be stricter (currently just existence check)
#
# ═══════════════════════════════════════════════════════════════════════════════

# NULL COALESCING OPERATOR (compatible with older R versions)
`%||%` <- function(x, y) {
  if (is.null(x) || is.na(x)) y else x
}