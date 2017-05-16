CC		?= gcc
RM		= rm -rf
MV		= mv
COV		= gcovr

TARGET		= librepublican_calendar.so

BASEFLAGS	= -Wall -Wextra -Werror -fPIC -Iinclude
CFLAGS		= $(BASEFLAGS) -O2
LDFLAGS		= -shared
COVFLAGS	= $(BASEFLAGS) --coverage -O0 -g
TESTFLAGS	= -lcmocka

SRC_DIR		= src
TEST_DIR	= test

SRCS		= time.c
OBJS		= $(addprefix $(SRC_DIR)/, $(SRCS:.c=.o))

all: $(TARGET)

$(TARGET): $(OBJS)
	$(CC) -o $@ $^ $(LDFLAGS)

test: $(TEST_DIR)/test_time.c
	$(CC) $(COVFLAGS) $(TESTFLAGS) -o $(TEST_DIR)/test_time.o $^
	./$(TEST_DIR)/test_time.o
	$(MV) *.g* $(TEST_DIR)

coverage: test
	$(COV) -r . --html --html-details -o $@.html
	$(COV) -r . -s

clean:
	$(RM) $(TEST_DIR)/*.gcda $(TEST_DIR)/*.gcno coverage.html $(OBJS) *.html
	$(RM) $(TEST_DIR)/*.o

fclean: clean
	$(RM) $(TARGET)

re: fclean all

.PHONY: all test coverage clean fclean re