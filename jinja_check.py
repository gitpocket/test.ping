import sys
import jinja2

path = sys.argv[1]
loader = jinja2.FileSystemLoader(path)
j2files = loader.list_templates()

def dummy():
    '''
    Simple dummy function to simulate custom filters.
    '''
    pass

env = jinja2.Environment(loader=loader)
env.filters['mandatory'] = dummy

exit = 0
for f in j2files:
    try:
        template = env.get_template(f)
    except (jinja2.TemplateSyntaxError) as e:
        print '********\n%s\n********' % e
        exit += 1
    else:
        print '%s: Syntax OK' % f

sys.exit(exit)
