#!/usr/bin/env python3
"""Build configuration UI for AryaLinux (curses TUI with CLI fallback)."""

import curses
import getpass
import os
import sys

PROPS_FILE = 'build-properties'

DEFAULT_PASSWORD = 'aryalinux'
DEFAULT_OS_VERSION = '26.6'
DEFAULT_OS_CODENAME = 'Phainix'

PROPERTY_DEFAULTS = {
    'DEV_NAME': '',
    'ROOT_PART': '',
    'HOME_PART': '',
    'FORMAT_HOME': 'n',
    'SWAP_PART': '',
    'FORMAT_SWAP': 'n',
    'LOCALE': 'en_IN.utf8',
    'KEYBOARD': 'us',
    'PAPER_SIZE': 'A4',
    'OS_NAME': 'AryaLinux',
    'OS_VERSION': DEFAULT_OS_VERSION,
    'OS_CODENAME': DEFAULT_OS_CODENAME,
    'DOMAIN_NAME': 'aryalinux.com',
    'FULLNAME': 'AryaLinux',
    'USERNAME': 'aryalinux',
    'HOST_NAME': 'aryalinux',
    'MULTICORE': 'y',
    'CREATE_BACKUPS': 'n',
    'INSTALL_XSERVER': 'n',
    'INSTALL_DESKTOP_ENVIRONMENT': 'n',
    'DESKTOP_ENVIRONMENT': '2',
    'INSTALL_BOOTLOADER': 'y',
    'CREATE_LIVE_ISO': 'y',
}

DESKTOP_CHOICES = {
    '1': 'XFCE',
    '2': 'MATE',
    '3': 'KDE',
    '4': 'GNOME',
    '5': 'LXQt',
}

MIN_ROWS = 24
MIN_COLS = 72


def use_cli_mode():
    return '--cli' in sys.argv or not sys.stdin.isatty() or not sys.stdout.isatty() \
        or os.environ.get('TERM', '') in ('', 'dumb')


def get_param_value(param_name, props_file=PROPS_FILE):
    try:
        with open(props_file) as handle:
            for line in handle:
                if line.startswith(param_name + '='):
                    return line.split('=', 1)[1].strip().strip('"')
    except OSError:
        pass
    return None


def write_build_properties(values, props_file=PROPS_FILE):
    order = [
        'DEV_NAME', 'ROOT_PART', 'HOME_PART', 'SWAP_PART',
        'LOCALE', 'OS_NAME', 'OS_VERSION', 'OS_CODENAME', 'DOMAIN_NAME',
        'KEYBOARD', 'PAPER_SIZE', 'FULLNAME', 'USERNAME', 'HOST_NAME',
        'MULTICORE', 'CREATE_BACKUPS', 'INSTALL_XSERVER',
        'INSTALL_BOOTLOADER', 'CREATE_LIVE_ISO',
    ]
    with open(props_file, 'w') as handle:
        for key in order:
            handle.write(f'{key}="{values.get(key, PROPERTY_DEFAULTS[key])}"\n')
        if values.get('HOME_PART', ''):
            handle.write(f'FORMAT_HOME="{values.get("FORMAT_HOME", "n")}"\n')
        if values.get('SWAP_PART', ''):
            handle.write(f'FORMAT_SWAP="{values.get("FORMAT_SWAP", "n")}"\n')
        if values.get('INSTALL_XSERVER', 'n').lower() in ('y', 'yes'):
            handle.write(
                f'INSTALL_DESKTOP_ENVIRONMENT="{values.get("INSTALL_DESKTOP_ENVIRONMENT", "n")}"\n'
            )
            if values.get('INSTALL_DESKTOP_ENVIRONMENT', 'n').lower() in ('y', 'yes'):
                handle.write(
                    f'DESKTOP_ENVIRONMENT="{values.get("DESKTOP_ENVIRONMENT", "2")}"\n'
                )


def yn_hint(default):
    return 'Y/n' if default.lower() in ('y', 'yes') else 'y/N'


def prompt(label, default=''):
    if default != '':
        response = input(f'{label} [{default}]: ').strip()
    else:
        response = input(f'{label}: ').strip()
    return response if response != '' else default


def cli_getpassword(label, default=DEFAULT_PASSWORD):
    password1 = getpass.getpass(f'{label} [{default}]: ')
    if password1 == '':
        return default
    password2 = getpass.getpass(f'Confirm {label.lower()}: ')
    if password1 == password2:
        return password1
    print('Passwords do not match. Please try again.')
    return cli_getpassword(label, default)


def cli_read_yes_no(label, default='n'):
    return prompt(f'{label} ({yn_hint(default)})', default)


def cli_collect_build_properties(props_file=PROPS_FILE):
    values = dict(PROPERTY_DEFAULTS)
    print()
    print('AryaLinux Build Configuration')
    print('Press Enter to accept the value shown in [brackets].')
    print()

    def section(title):
        print()
        print(title)
        print('-' * len(title))

    section('Storage')
    values['DEV_NAME'] = prompt('Bootloader device', values['DEV_NAME'])
    values['ROOT_PART'] = prompt('Root partition', values['ROOT_PART'])
    values['HOME_PART'] = prompt('Home partition (optional)', values['HOME_PART'])
    if values['HOME_PART']:
        values['FORMAT_HOME'] = cli_read_yes_no('Format home partition', 'n')
    values['SWAP_PART'] = prompt('Swap partition (optional)', values['SWAP_PART'])
    if values['SWAP_PART']:
        values['FORMAT_SWAP'] = cli_read_yes_no('Format swap partition', 'n')

    section('Locale and regional settings')
    values['LOCALE'] = prompt('Locale', values['LOCALE'])
    values['KEYBOARD'] = prompt('Keyboard layout', values['KEYBOARD'])
    values['PAPER_SIZE'] = prompt('Printer paper size', values['PAPER_SIZE'])

    section('System identity')
    values['OS_NAME'] = prompt('OS name', values['OS_NAME'])
    values['OS_VERSION'] = prompt('OS version', values['OS_VERSION'])
    values['OS_CODENAME'] = prompt('OS codename', values['OS_CODENAME'])
    values['DOMAIN_NAME'] = prompt('Domain name', values['DOMAIN_NAME'])

    section('User account')
    values['FULLNAME'] = prompt('Full name', values['FULLNAME'])
    values['USERNAME'] = prompt('Username', values['USERNAME'])
    values['HOST_NAME'] = prompt('Computer name', values['HOST_NAME'])

    section('Build options')
    values['MULTICORE'] = cli_read_yes_no('Use multiple CPU cores for compilation', 'y')
    values['CREATE_BACKUPS'] = cli_read_yes_no('Create tarball backups after each stage', 'n')
    values['INSTALL_XSERVER'] = cli_read_yes_no('Install X server', 'n')
    if values['INSTALL_XSERVER'].lower() in ('y', 'yes'):
        values['INSTALL_DESKTOP_ENVIRONMENT'] = cli_read_yes_no(
            'Install desktop environment', 'n'
        )
        if values['INSTALL_DESKTOP_ENVIRONMENT'].lower() in ('y', 'yes'):
            print()
            print('Desktop environment:')
            for key, name in DESKTOP_CHOICES.items():
                print(f'  {key}  {name}')
            values['DESKTOP_ENVIRONMENT'] = prompt('Selection', '2')

    section('Post-build')
    values['INSTALL_BOOTLOADER'] = cli_read_yes_no('Install bootloader', 'y')
    values['CREATE_LIVE_ISO'] = cli_read_yes_no('Create live ISO', 'y')
    print()

    write_build_properties(values, props_file)
    return {
        'root': cli_getpassword('Root password'),
        'user': cli_getpassword('User password'),
    }


def cli_collect_passwords():
    return {
        'root': cli_getpassword('Root password'),
        'user': cli_getpassword('User password'),
    }


def cli_startup_menu():
    print()
    print('AryaLinux Build Orchestrator')
    print('============================')
    print()
    print('  1  Start a new build')
    print('  2  Resume a previous build')
    print()
    choice = prompt('Choice', '1')
    if choice == '1':
        return 'fresh', None
    if choice == '2':
        partition = prompt('Root partition of the in-progress build (leave empty to exit)', '')
        return ('resume', partition) if partition else ('exit', None)
    return 'exit', None


def collect_build_properties(props_file=PROPS_FILE):
    if not use_cli_mode():
        try:
            return tui_collect_build_properties(props_file)
        except (curses.error, KeyboardInterrupt):
            curses.endwin()
    return cli_collect_build_properties(props_file)


def collect_passwords():
    if not use_cli_mode():
        try:
            return tui_collect_passwords()
        except (curses.error, KeyboardInterrupt):
            curses.endwin()
    return cli_collect_passwords()


def run_startup_menu():
    if not use_cli_mode():
        try:
            return tui_startup_menu()
        except (curses.error, KeyboardInterrupt):
            curses.endwin()
    return cli_startup_menu()


def _centered_window(stdscr, height, width):
    max_y, max_x = stdscr.getmaxyx()
    height = min(height, max_y - 2)
    width = min(width, max_x - 2)
    top = max(0, (max_y - height) // 2)
    left = max(0, (max_x - width) // 2)
    return curses.newwin(height, width, top, left)


def _draw_title(win, title):
    height, width = win.getmaxyx()
    win.box()
    if width > len(title) + 4:
        x = max(1, (width - len(title) - 2) // 2)
        win.addstr(0, x, f' {title} ', curses.A_BOLD)


def _safe_addstr(win, y, x, text, attr=0):
    height, width = win.getmaxyx()
    if y < 0 or y >= height or x >= width - 1:
        return
    clip = text[: max(0, width - x - 1)]
    if clip:
        win.addstr(y, x, clip, attr)


def _toggle_yes_no(value):
    return 'n' if value.lower() in ('y', 'yes') else 'y'


def _page_definitions(values):
    pages = [
        ('Storage', [
            ('DEV_NAME', 'Bootloader device', 'text'),
            ('ROOT_PART', 'Root partition', 'text'),
            ('HOME_PART', 'Home partition (optional)', 'text'),
        ]),
        ('Locale', [
            ('LOCALE', 'Locale', 'text'),
            ('KEYBOARD', 'Keyboard layout', 'text'),
            ('PAPER_SIZE', 'Paper size (A4/letter)', 'text'),
        ]),
        ('System identity', [
            ('OS_NAME', 'OS name', 'text'),
            ('OS_VERSION', 'OS version', 'text'),
            ('OS_CODENAME', 'OS codename', 'text'),
            ('DOMAIN_NAME', 'Domain name', 'text'),
        ]),
        ('User account', [
            ('FULLNAME', 'Full name', 'text'),
            ('USERNAME', 'Username', 'text'),
            ('HOST_NAME', 'Computer name', 'text'),
        ]),
        ('Build options', [
            ('MULTICORE', 'Use multiple CPU cores', 'yesno'),
            ('CREATE_BACKUPS', 'Create stage backups', 'yesno'),
            ('INSTALL_XSERVER', 'Install X server', 'yesno'),
        ]),
    ]
    if values.get('INSTALL_XSERVER', 'n').lower() in ('y', 'yes'):
        desktop_fields = [
            ('INSTALL_DESKTOP_ENVIRONMENT', 'Install desktop environment', 'yesno'),
        ]
        if values.get('INSTALL_DESKTOP_ENVIRONMENT', 'n').lower() in ('y', 'yes'):
            desktop_fields.append(
                ('DESKTOP_ENVIRONMENT', 'Desktop (1 XFCE 2 MATE 3 KDE 4 GNOME 5 LXQt)', 'text')
            )
        pages.append(('Desktop environment', desktop_fields))
    pages.append(('Security', []))
    pages.append(('Post-build', [
        ('INSTALL_BOOTLOADER', 'Install bootloader', 'yesno'),
        ('CREATE_LIVE_ISO', 'Create live ISO', 'yesno'),
    ]))
    return pages


def _expanded_fields(page_fields, values):
    fields = list(page_fields)
    if any(key == 'HOME_PART' for key, _, _ in page_fields) and values.get('HOME_PART', ''):
        fields.append(('FORMAT_HOME', 'Format home partition', 'yesno'))
    if any(key == 'SWAP_PART' for key, _, _ in page_fields) and values.get('SWAP_PART', ''):
        fields.append(('FORMAT_SWAP', 'Format swap partition', 'yesno'))
    return fields


def _edit_text(stdscr, win, y, x, width, value, secret=False):
    cursor = len(value)
    while True:
        display = ('*' * len(value)) if secret else value
        _safe_addstr(win, y, x, ' ' * max(1, width - 1))
        _safe_addstr(win, y, x, display[: width - 1])
        stdscr.move(y + win.getbegyx()[0], x + min(cursor, width - 2))
        stdscr.refresh()
        win.refresh()
        key = stdscr.getch()
        if key in (curses.KEY_ENTER, 10, 13, 9, curses.KEY_DOWN, curses.KEY_BTAB):
            return value
        if key in (curses.KEY_UP,):
            return value
        if key in (27,):  # Esc handled by caller
            return value
        if key in (curses.KEY_BACKSPACE, 127, 8):
            value = value[: max(0, cursor - 1)]
            cursor = max(0, cursor - 1)
            continue
        if key == curses.KEY_DC:
            value = value[:cursor] + value[cursor + 1:]
            continue
        if key == curses.KEY_LEFT:
            cursor = max(0, cursor - 1)
            continue
        if key == curses.KEY_RIGHT:
            cursor = min(len(value), cursor + 1)
            continue
        if 32 <= key <= 126 and len(value) < width - 2:
            ch = chr(key)
            value = value[:cursor] + ch + value[cursor:]
            cursor += 1


def _run_config_wizard(stdscr, values, passwords):
    page_index = 0
    while True:
        pages = _page_definitions(values)
        page_index = min(page_index, len(pages) - 1)
        title, page_fields = pages[page_index]
        fields = _expanded_fields(page_fields, values)

        if title == 'Security':
            height, width = 18, 68
            win = _centered_window(stdscr, height, width)
            _draw_title(win, title)
            _safe_addstr(win, 2, 2, f'Leave blank for default: {DEFAULT_PASSWORD}')
            _safe_addstr(win, 4, 2, 'Root password:')
            _safe_addstr(win, 5, 2, ' ' * 40, curses.A_UNDERLINE)
            passwords['root'] = _edit_text(stdscr, win, 5, 2, 40, passwords.get('root', ''), secret=True)
            if passwords['root'] == '':
                passwords['root'] = DEFAULT_PASSWORD
            _safe_addstr(win, 7, 2, 'User password:')
            _safe_addstr(win, 8, 2, ' ' * 40, curses.A_UNDERLINE)
            passwords['user'] = _edit_text(stdscr, win, 8, 2, 40, passwords.get('user', ''), secret=True)
            if passwords['user'] == '':
                passwords['user'] = DEFAULT_PASSWORD
            _draw_nav_help(win, page_index, len(pages))
            key = stdscr.getch()
            if key in (curses.KEY_LEFT, ord('b'), ord('B')) and page_index > 0:
                page_index -= 1
                continue
            if key in (curses.KEY_ENTER, 10, 13, ord('n'), ord('N'), curses.KEY_RIGHT):
                if page_index >= len(pages) - 1:
                    return
                page_index += 1
                continue
            if key == 27:
                raise KeyboardInterrupt
            continue

        field_count = max(1, len(fields))
        height = min(max(12, field_count * 2 + 8), curses.LINES - 2)
        width = min(74, curses.COLS - 2)
        win = _centered_window(stdscr, height, width)
        _draw_title(win, title)
        _safe_addstr(win, 2, 2, 'Tab/Up/Down: move   Enter: edit/next   Esc: cancel')

        field_index = 0
        while True:
            row = 4
            for idx, (key, label, kind) in enumerate(fields):
                attr = curses.A_REVERSE if idx == field_index else 0
                current = values.get(key, PROPERTY_DEFAULTS.get(key, ''))
                if kind == 'yesno':
                    shown = f'[{current.upper()}]'
                else:
                    shown = current if current else '(empty)'
                _safe_addstr(win, row, 2, f'{label}:', attr)
                _safe_addstr(win, row + 1, 4, shown[: width - 6], attr)
                row += 2
            _draw_nav_help(win, page_index, len(pages))
            win.refresh()
            key = stdscr.getch()

            if key in (curses.KEY_UP, curses.KEY_BTAB):
                field_index = (field_index - 1) % len(fields)
                continue
            if key in (curses.KEY_DOWN, 9):
                field_index = (field_index + 1) % len(fields)
                continue
            if key in (curses.KEY_LEFT, ord('b'), ord('B')):
                if page_index > 0:
                    page_index -= 1
                break
            if key in (curses.KEY_RIGHT, ord('n'), ord('N')):
                if page_index >= len(pages) - 1:
                    return
                page_index += 1
                break
            if key in (curses.KEY_ENTER, 10, 13) and page_index >= len(pages) - 1:
                return
            if key == 27:
                raise KeyboardInterrupt

            fkey, flabel, fkind = fields[field_index]
            if key in (curses.KEY_ENTER, 10, 13, ord(' ')):
                if fkind == 'yesno':
                    values[fkey] = _toggle_yes_no(values.get(fkey, 'n'))
                elif fkind == 'text':
                    _safe_addstr(win, field_index * 2 + 5, 4, ' ' * (width - 6))
                    values[fkey] = _edit_text(
                        stdscr, win, field_index * 2 + 5, 4, width - 6,
                        values.get(fkey, PROPERTY_DEFAULTS.get(fkey, ''))
                    )
                continue

            if key in (curses.KEY_ENTER, 10, 13) and field_index == len(fields) - 1:
                page_index += 1
                break


def _draw_nav_help(win, page_index, page_count):
    height, width = win.getmaxyx()
    help_y = height - 2
    if page_index >= page_count - 1:
        nav = '[B] Back   [Enter] Finish'
    else:
        nav = '[B] Back   [N] Next'
    _safe_addstr(win, help_y, 2, nav + ('   Page %d/%d' % (page_index + 1, page_count)))


def tui_collect_build_properties(props_file=PROPS_FILE):
    def main(stdscr):
        curses.curs_set(1)
        stdscr.keypad(True)
        if curses.COLS < MIN_COLS or curses.LINES < MIN_ROWS:
            raise curses.error('Terminal too small (need at least %dx%d)' % (MIN_COLS, MIN_ROWS))
        values = dict(PROPERTY_DEFAULTS)
        passwords = {}
        _run_config_wizard(stdscr, values, passwords)
        write_build_properties(values, props_file)
        return passwords

    return curses.wrapper(main)


def tui_collect_passwords():
    def main(stdscr):
        curses.curs_set(1)
        stdscr.keypad(True)
        win = _centered_window(stdscr, 14, 60)
        _draw_title(win, 'Security')
        _safe_addstr(win, 2, 2, f'Leave blank for default: {DEFAULT_PASSWORD}')
        passwords = {}
        _safe_addstr(win, 4, 2, 'Root password:')
        passwords['root'] = _edit_text(stdscr, win, 5, 2, 40, '', secret=True) or DEFAULT_PASSWORD
        _safe_addstr(win, 7, 2, 'User password:')
        passwords['user'] = _edit_text(stdscr, win, 8, 2, 40, '', secret=True) or DEFAULT_PASSWORD
        _safe_addstr(win, 10, 2, 'Press Enter to continue')
        stdscr.getch()
        return passwords

    return curses.wrapper(main)


def tui_startup_menu():
    def main(stdscr):
        curses.curs_set(0)
        stdscr.keypad(True)
        options = [
            'Start a new build',
            'Resume a previous build',
            'Exit',
        ]
        selected = 0
        resume_partition = ''

        while True:
            win = _centered_window(stdscr, 14, 54)
            win.erase()
            _draw_title(win, 'AryaLinux Build Orchestrator')
            _safe_addstr(win, 2, 2, 'Use arrow keys, Enter to select')
            for idx, label in enumerate(options):
                prefix = '>' if idx == selected else ' '
                attr = curses.A_REVERSE if idx == selected else 0
                _safe_addstr(win, 4 + idx, 4, f'{prefix} {label}', attr)
            if selected == 1 and resume_partition:
                _safe_addstr(win, 10, 2, f'Partition: {resume_partition}')
            win.refresh()
            key = stdscr.getch()
            if key in (curses.KEY_UP, ord('k')):
                selected = (selected - 1) % len(options)
            elif key in (curses.KEY_DOWN, ord('j')):
                selected = (selected + 1) % len(options)
            elif key == 27:
                return 'exit', None
            elif key in (curses.KEY_ENTER, 10, 13):
                if selected == 0:
                    return 'fresh', None
                if selected == 2:
                    return 'exit', None
                resume_partition = _prompt_resume_partition(stdscr, resume_partition)
                if resume_partition:
                    return 'resume', resume_partition

    return curses.wrapper(main)


def _prompt_resume_partition(stdscr, current=''):
    win = _centered_window(stdscr, 10, 60)
    _draw_title(win, 'Resume build')
    _safe_addstr(win, 2, 2, 'Root partition of the in-progress build')
    _safe_addstr(win, 4, 2, 'Leave empty to go back')
    value = _edit_text(stdscr, win, 6, 2, 50, current)
    return value.strip()
