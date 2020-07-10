onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib tag_ram_opt

do {wave.do}

view wave
view structure
view signals

do {tag_ram.udo}

run -all

quit -force
