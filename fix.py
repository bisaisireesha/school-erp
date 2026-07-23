import sys

def fix_homework():
    with open('lib/screens/homework/homework_screen.dart', 'r') as f:
        lines = f.readlines()
    if '  );\n' in lines[871]:
        lines[871] = lines[871].replace('  );\n', '  ));\n')
    with open('lib/screens/homework/homework_screen.dart', 'w') as f:
        f.writelines(lines)

def fix_fees():
    with open('lib/screens/fees/fees_screen.dart', 'r') as f:
        lines = f.readlines()
    
    # Fix .toList() in spread
    lines[44] = lines[44].replace('.toList(),', ',')
    lines[505] = lines[505].replace('.toList(),', ',')
    lines[590] = lines[590].replace('.toList(),', ',')
    lines[785] = lines[785].replace('.toList(),', ',')

    new_lines = []
    for i, line in enumerate(lines):
        n = i + 1
        if 117 <= n <= 211:
            continue
        if 212 <= n <= 273:
            continue
        if 792 <= n <= 885:
            continue
        new_lines.append(line)
        
    with open('lib/screens/fees/fees_screen.dart', 'w') as f:
        f.writelines(new_lines)

fix_homework()
fix_fees()
print('Fixed!')
