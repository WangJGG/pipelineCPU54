.data
    A:.space 240           # a数组
    B:.space 240           # b数组
    C:.space 240           # c数组
    D:.space 240           # d数组

.text
    j main
exc:
    nop
    j exc

main:
    # 初始化a[0]，b[0]，c[0]，d[0]
    addi $4, $0, 0         # a[0] = 0
    addi $5, $0, 1         # b[0] = 1
    addi $6, $0, 0         # c[0] = 0
    addi $7, $0, 0         # d[0] = 0
    addi $8, $0, 4         # 计数器增量,+4每次
    addi $9, $0, 0         # a[i - 1]
    addi $10, $0, 1        # b[i - 1]
    addi $11, $0, 0        # 分段区间标识
    addi $12, $0, 240      # 数组总长度240
    addi $13, $0, 3        # 常数3
    addi $17, $0, 0        # c[i]清零
    addi $18, $0, 0        # d[i]清零

    # 初始化数组A, B
    sw $4, A               # a[0]
    sw $5, B               # b[0]

loop:
    # 计算a[i] = a[i-1] + i
    srl $14, $8, 2         # $14 = i / 4
    add $9, $9, $14        # a[i] = a[i-1] + i
    lui $15, 0x0000
    addu $15, $15, $8
    sw $9, A($15)          # 存储a[i]

    # 计算b[i] = b[i-1] + 3 * i
    mul $16, $13, $14      # 3 * i
    add $10, $10, $16      # b[i] = b[i-1] + 3 * i
    lui $15, 0x0000
    addu $15, $15, $8
    sw $10, B($15)         # 存储b[i]

    # 判断i的范围并计算c[i]和d[i]
    slti $11, $8, 80       # i < 20*4?
    bne $11, $0, case1     # 如果i < 80跳转

    slti $11, $8, 160      # 20*4 <= i < 40*4?
    bne $11, $0, case2     # 如果i < 160跳转

case3:
    # 40 <= i < 60时，c[i] = a[i] * b[i], d[i] = c[i] * b[i]
    mul $17, $9, $10       # c[i] = a[i] * b[i]
    sw $17, C($15)         # 存储c[i]
    mul $18, $17, $10      # d[i] = c[i] * b[i]
    sw $18, D($15)         # 存储d[i]
    j update_next

case1:
    # 0 <= i < 20时，c[i] = a[i], d[i] = b[i]
    move $17, $9           # c[i] = a[i]
    sw $17, C($15)         # 存储c[i]
    move $18, $10          # d[i] = b[i]
    sw $18, D($15)         # 存储d[i]
    j update_next

case2:
    # 20 <= i < 40时，c[i] = a[i] + b[i], d[i] = c[i] * b[i]
    add $17, $9, $10       # c[i] = a[i] + b[i]
    sw $17, C($15)         # 存储c[i]
    mul $18, $17, $10      # d[i] = c[i] * b[i]
    sw $18, D($15)         # 存储d[i]
    j update_next

update_next:
    # 增加i，更新循环
    addi $8, $8, 4         # i = i + 4
    bne $8, $12, loop      # 如果i < 240，继续循环

