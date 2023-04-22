import re

regex = r"@melembredisto (?:em|daqui) (\d+(?:\.\d+)?)\s*(\w+)"

messages = ["@melembredisto em 5 horas", "@melembredisto daqui 10 minutos"]
# amanha

for string in messages:
    match = re.search(regex, string)
    if match:
        value = int(match.group(1))
        measure = match.group(2)
        print(f"Value: {value}, Measure: {measure}")
