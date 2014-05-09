import sys
import jinja2

exit = 0
for j2 in sys.argv[1:]:
    try:
        with open(j2) as f:
            jinja2.Template(f.read())
    except (jinja2.TemplateSyntaxError) as e:
        print '********\n%s\n********' % e
        exit += 1
    else:
        print '%s: Syntax OK' % j2

sys.exit(exit)
