import sys
import jinja2

path = sys.argv[1]
loader = jinja2.FileSystemLoader(path)
files = loader.list_templates()

def dummy():
    '''
    Simple dummy function to simulate custom filters.
    '''
    pass

# Setup env and custom filters
env = jinja2.Environment(loader=loader)
env.filters['mandatory'] = dummy

# exit 0 unless changed below
exit = 0

# strip out all files that don't end in .j2
j2files = []
for f in files:
    if f.endswith('.j2'):
        j2files.append(f)

# perform the syntax check on the j2 files
for f in j2files:
    try:
        template = env.get_template(f)
    except (jinja2.TemplateSyntaxError) as e:
        print '********\n%s\n********' % e
        exit += 1
    else:
        print '%s: Syntax OK' % f

sys.exit(exit)
