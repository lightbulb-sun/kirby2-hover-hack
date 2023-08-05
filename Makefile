ROM = kirby2.gb
NAME = hack
SOURCE_FILE = $(NAME).asm
OBJECT_FILE = $(NAME).o
OUTPUT_ROM = $(NAME).gb

$(OUTPUT_ROM): $(OBJECT_FILE)
	rgblink -O $(ROM) -o $@ $<
	rgbfix -f gh $@

$(OBJECT_FILE): $(SOURCE_FILE)
	rgbasm  -E $< -o $@

clean:
	rm -rf $(OBJECT_FILE) $(OUTPUT_ROM)
