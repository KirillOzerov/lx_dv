#include <ncurses.h>
#include <locale.h>
#include <stdio.h>

#define DX 7
#define DY 7

int main(int argc, char *argv[])
{
    if (argc != 2)
    {
        printf("Введите название файла.\n");
        return 0;
    }

    FILE *file = fopen(argv[1], "r");
    if (!file) return 1;

    WINDOW *frame, *win;
    int c = 0;
    char buffer[1024];
    int line_count = 0;

    setlocale(LC_ALL, "ru_RU.UTF-8");
    initscr();
    noecho();
    cbreak();
    refresh();

    frame = newwin(LINES - 2*DY, COLS - 2*DX, DY, DX);
    box(frame, 0, 0);
    mvwaddstr(frame, 0, (int)((COLS - 2*DX) / 2), argv[1]);
    wrefresh(frame);

    win = newwin(LINES - 2*DY - 2, COLS - 2*DX - 2, DY + 1, DX + 1);
    keypad(win, TRUE);
    scrollok(win, TRUE);

    int max_lines = LINES - 2*DY - 2;
    while (line_count < max_lines && fgets(buffer, sizeof(buffer), file)) {
        wprintw(win, "%s", buffer);
        line_count++;
    }
    wrefresh(win);

    while((c = wgetch(win)) != 27)
    {
        if (c == ' ') {
            if (fgets(buffer, sizeof(buffer), file)) {
                wprintw(win, "%s", buffer);
                wrefresh(win);
                line_count++;
            }
        }
    }
    
    fclose(file);
    delwin(win);
    delwin(frame);
    endwin();
    return 0;
}
