import sys
import jinja2

def dummy():
    '''
    Simple dummy function to simulate custom filters.
    '''
    pass

env = jinja2.Environment(loader=FileSystemLoader(sys.argv[1]))
env.filters['mandatory'] = dummy

exit = 0
try:
    template = env.get_template(sys.argv[2:])
except (jinja2.TemplateSyntaxError) as e:
    print '********\nError: %s\n********' % e
    exit += 1
else:
    print '%s: Syntax OK' % j2

sys.exit(exit)
