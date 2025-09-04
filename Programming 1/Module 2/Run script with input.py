# Module 2 exercise

# # 1. Temperature conversion ----
#     # Get user input
# degrees_farenheit = input(prompt = "Degrees Fareheit: ")
#     # Coerce to numeric
# degrees_farenheit = float(degrees_farenheit)
#     # Convert to Celsius & round
# degrees_celsius = (degrees_farenheit - 32) / 1.8
# degrees_celsius = round(degrees_celsius, 1)
#     # Output input & converted values
# print(f"Farenheit {degrees_farenheit} = Celsius {degrees_celsius}")
# ###############################################


# # 2. Accrued intrest on capital
#     # Get user input
# capital_SEK = input(prompt = "Investment capital (SEK): ")
# interest_rate_percent = input(prompt = "Interest rate in %: ")
# years = input(prompt = "How many years to wait: ")
#     # Coerce to numeric
# capital_SEK = int(capital_SEK) # may as well be float...?
# interest_rate_percent = float(interest_rate_percent)
# years = int(years)
#     # Calculate new capital
# interest_rate_ff = interest_rate_percent / 100
# capital_final_SEK = capital_SEK * (1 + interest_rate_ff)**years
# capital_final_SEK = round(capital_final_SEK, 2)
#     # Output results
# print(f"Final capital: {capital_final_SEK} SEK")
# print(f"According to formula: Capital * (1 + Interest)^Years")
# ####################################


# 