#!/usr/bin/env python

import sys
import os
import jinja2
import argparse
import logging

log = logging.getLogger('tpl')
logpattern = '%(asctime)s %(levelname)s %(message)s'
log_handler = logging.StreamHandler()
log_handler.setFormatter(logging.Formatter(logpattern))
log.addHandler(log_handler)
log.setLevel(logging.DEBUG)


def check_src_path(path):
    if not os.path.exists(path):
        log.error('Path does not exists')
        log.error(path)
        sys.exit(1)


def render_template(folder, name, env_prefix):
    env = jinja2.Environment(loader=jinja2.FileSystemLoader(folder),
                             undefined=jinja2.StrictUndefined)
    tpl = env.get_template(name)
    context = {k: v for k, v in os.environ.items()}
    if env_prefix:
        context = {k: v for k, v in os.environ.items() if k.startswith(env_prefix)}
    rendered = tpl.render(context)
    log.debug(rendered)
    return rendered


def main(args):
    check_src_path(args.template_folder)
    with open(args.dest, 'w') as fh:
        _tpl = render_template(args.template_folder, args.template_name, args.var_prefix)
        fh.write(_tpl)


if __name__ == '__main__':
    ap = argparse.ArgumentParser()
    ap.add_argument('--var-prefix')
    ap.add_argument('--template-folder', help="Template folder path")
    ap.add_argument('--template-name', help="Template name")
    ap.add_argument('--dest', help="Destination file path")

    args = ap.parse_args()
    log.debug(args)
    
    main(args)
