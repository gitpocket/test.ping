import sys
import jinja2

path = sys.argv[1]
j2files = sys.argv[2:]

def dummy():
    '''
    Simple dummy function to simulate custom filters.
    '''
    pass

env = jinja2.Environment(loader=jinja2.FileSystemLoader(path))
env.filters['mandatory'] = dummy

exit = 0
for f in j2files:
    try:
        template = env.get_template(f)
    except (jinja2.TemplateSyntaxError) as e:
        print '********\nError: %s\n********' % e
        exit += 1
    else:
        print '%s: Syntax OK' % j2

sys.exit(exit)
