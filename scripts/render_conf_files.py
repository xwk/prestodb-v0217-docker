#!/usr/bin/env python
import argparse

from jinja2 import Environment, FileSystemLoader


def render(vars):
    env = Environment(loader=FileSystemLoader('.', encoding='utf8'))
    files = [
        'etc/node.properties.template',
        'etc/config.properties.template',
    ]
    for path in files:
        tpl = env.get_template(path)
        rendered = tpl.render(vars)

        output_fpath = path[:-9]
        with open(output_fpath, 'w') as f:
            f.write(rendered)
            print("Rendered {}".format(output_fpath))


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description="Process build args from Docker")

    # Accept arbitrary options like --foo=bar
    parsed, unknown = parser.parse_known_args()

    for arg in unknown:
        if arg.startswith(("-", "--")):
            parser.add_argument(arg.split('=')[0])
    args = parser.parse_args()

    render(vars(args))
