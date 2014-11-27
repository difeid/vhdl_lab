#!/usr/bin/env python3
while True :
	action = input('Кодировать - c, Декодировать - d, Замена - z, Выход - q: ')
	if (action != 'c') and (action != 'd') and (action != 'z') : break
	if action != 'z' :
		while 1:
			code = input('Введите код: ')
			try:
				code = int(code)
				break
			except ValueError: print('Вводите число')
	if action == 'c' :
		file_r = open('open.txt', 'r')
		text = file_r.read()
		file_r.close()
		file_w = open('close.txt', 'w')
		for s in text :
			r = ord(s)
			if r >= 32 :
				r = r + code
			sim=chr(r)
			file_w.write(sim)
		file_w.close()
	elif action == 'd' :
		file_r = open('close.txt', 'r')
		text = file_r.read()
		file_r.close()
		file_w = open('open.txt', 'w')
		# Декодировать
		file_w.write('Всё не так просто, как кажется')
		file_w.close()
	elif action == 'z' :
		zam1 = input('Введите первый символ: ')
		zam2 = input('Введите второй символ: ')
		zam1 = zam1[0]
		zam2 = 'LAMER!'
		file_r = open('open.txt', 'r')
		text = file_r.read()
		file_r.close()
		file_w = open('open.txt', 'w')
		for s in text :
			# Перекрестная замена символов
			if s == zam1 : s = zam2
			else :
				if s == zam2 : s = zam2
			file_w.write(s)
		file_w.close()
