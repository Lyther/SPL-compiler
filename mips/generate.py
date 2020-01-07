import sys
import re

r = ['t1', 't2', 't3', 't4', 't5', 't6', 't7', 't8', 't9', 's0', 's1', 's2', 's3', 's4', 's5', 's6', 's7']
t = {}
o = {}
v = []


def read_var(ir):
    global v
    pattern = '(v[0-9]+)'
    for line in ir:
        matched = re.findall(pattern, ' '.join(line))
        v += matched


def read_ir(filename):
    lines = []
    for line in open(filename, 'r', encoding='utf-8'):
        line = line.replace('\r', '').replace('\n', '')
        if line == '':
            continue
        lines.append(line.split(' '))
    return lines


def get_reg(string):
    try:
        v.remove(string)
    except:
        pass
    if string in t:
        return '$' + t[string]
    else:
        keys = []
        for key in t:
            keys.append(key)
        for key in keys:
            if 'v' in key and key not in v:
                o[t[key]] = 1
                del t[key]
        for reg in r:
            if o[reg] == 1:
                t[string] = reg
                o[reg] = 0
                return '$' + reg


def translate(line):
    if line[0] == 'LABEL':
        return line[1] + ':'
    if line[1] == ':=':
        if len(line) == 3:
            if line[-1][0] == '#':
                return '\tli %s,%s' % (get_reg(line[0]), line[-1].replace('#', ''))
            else:
                return '\tmove %s,%s' % (get_reg(line[0]), get_reg(line[2]))
        if len(line) == 5:
            if line[3] == '+':
                if line[-1][0] == '#':
                    return '\taddi %s,%s,%s' % (get_reg(line[0]), get_reg(line[2]), line[-1].replace('#', ''))
                else:
                    return '\tadd %s,%s,%s' % (get_reg(line[0]), get_reg(line[2]), get_reg(line[-1]))
            elif line[3] == '-':
                if line[-1][0] == '#':
                    return '\taddi %s,%s,-%s' % (get_reg(line[0]), get_reg(line[2]), line[-1].replace('#', ''))
                else:
                    return '\tsub %s,%s,%s' % (get_reg(line[0]), get_reg(line[2]), get_reg(line[-1]))
            elif line[3] == '*':
                return '\tmul %s,%s,%s' % (get_reg(line[0]), get_reg(line[2]), get_reg(line[-1]))
            elif line[3] == '/':
                return '\tdiv %s,%s\n\tmflo %s' % (get_reg(line[2]), get_reg(line[-1]), get_reg(line[0]))
            elif line[3] == '<':
                return '\tslt %s,%s,%s' % (get_reg(line[0]), get_reg(line[2]), get_reg(line[-1]))
            elif line[3] == '>':
                return '\tslt %s,%s,%s' % (get_reg(line[0]), get_reg(line[-1]), get_reg(line[2]))
        if line[2] == 'READ':
            return '\taddi $sp,$sp,-4\n\tsw $ra,0($sp)\n\tjal %s\n\tlw $ra,0($sp)\n\tmove %s,$v0\n\taddi $sp,$sp,4' \
                   % (line[2].lower(), get_reg(line[0]))
        if line[2] == 'CALL':
            return '\taddi $sp,$sp,-24\n\tsw $t0,0($sp)\n\tsw $ra,4($sp)\n\tsw $t1,8($sp)\n\tsw $t2,12($sp)\n\t' \
                   'sw $t3,16($sp)\n\tsw $t4,20($sp)\n\tjal %s\n\tlw $a0,0($sp)\n\tlw $ra,4($sp)\n\tlw $t1,8($sp)' \
                   '\n\tlw $t2,12($sp)\n\tlw $t3,16($sp)\n\tlw $t4,20($sp)\n\taddi $sp,$sp,24\n\tmove %s $v0' \
                   % (line[-1], get_reg(line[0]))
    if line[0] == 'GOTO':
        return '\tj %s' % line[1]
    if line[0] == 'RETURN':
        return '\tmove $v0,%s\n\tjr $ra' % get_reg(line[1])
    if line[0] == 'IF':
        if line[2] == '==':
            return '\tbeq %s,%s,%s' % (get_reg(line[1]), get_reg(line[3]), line[-1])
        if line[2] == '!=':
            return '\tbne %s,%s,%s' % (get_reg(line[1]), get_reg(line[3]), line[-1])
        if line[2] == '>':
            return '\tbgt %s,%s,%s' % (get_reg(line[1]), get_reg(line[3]), line[-1])
        if line[2] == '<':
            return '\tblt %s,%s,%s' % (get_reg(line[1]), get_reg(line[3]), line[-1])
        if line[2] == '>=':
            return '\tbge %s,%s,%s' % (get_reg(line[1]), get_reg(line[3]), line[-1])
        if line[2] == '<=':
            return '\tble %s,%s,%s' % (get_reg(line[1]), get_reg(line[3]), line[-1])
    if line[0] == 'FUNCTION':
        return '%s:' % line[1]
    if line[0] == 'READ' or line[0] == 'WRITE':
        return '\taddi $sp,$sp,-4\n\tsw $ra,0($sp)\n\tjal %s\n\tlw $ra,0($sp)\n\taddi $sp,$sp,4' % (line[0].lower())
    if line[0] == 'CALL':
        return '\taddi $sp,$sp,-24\n\tsw $t0,0($sp)\n\tsw $ra,4($sp)\n\tsw $t1,8($sp)\n\tsw $t2,12($sp)\n\t' \
               'sw $t3,16($sp)\n\tsw $t4,20($sp)\n\tjal %s\n\tlw $a0,0($sp)\n\tlw $ra,4($sp)\n\tlw $t1,8($sp)\n\t' \
               'lw $t2,12($sp)\n\tlw $t3,16($sp)\n\tlw $t4,20($sp)\n\taddi $sp,$sp,24\n\tmove %s $v0'\
               % (line[-1], get_reg(line[0]))
    if line[0] == 'ARG':
        return '\tmove $t0,$a0\n\tmove $a0,%s' % get_reg(line[-1])
    if line[0] == 'PARAM':
        t[line[-1]] = 'a0'
    return ''


def write_asm(obj):
    f = open(sys.argv[2], 'w')
    template = '''.data
_prompt: .asciiz "Enter an integer:"
_ret: .asciiz "\\n"
.globl main
.text
read:
    li $v0,4
    la $a0,_prompt
    syscall
    li $v0,5
    syscall
    jr $ra
write:
    li $v0,1
    syscall
    li $v0,4
    la $a0,_ret
    syscall
    move $v0,$0
    jr $ra
'''
    f.write(template)
    for line in obj:
        f.write(line + '\n')
    f.close()


def parser():
    for reg in r:
        o[reg] = 1
    ir = read_ir(sys.argv[1])
    read_var(ir)
    obj = []
    for line in ir:
        obj_line = translate(line)
        if obj_line == '':
            continue
        obj.append(obj_line)
    write_asm(obj)


if __name__ == '__main__':
    parser()
