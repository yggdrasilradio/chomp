' CHOMP by Rick Adams 

        dim a(9, 9)

        ' Randomize the RND function
        r = rnd(-timer)

        ' Reset machine on BREAK
        on brk goto 500

        ' Set up video mode and palette colors
        rgb
        width 80
        palette 0, 0                ' background: 0 black
        palette 8, 25               ' foreground: 0 white

        ' Clear screen
        cls

        ' Intro
        print "CHOMP--AVOID THE POISON IN THE COOKIE"
        print
        print "CHOOSE A SQUARE: EXAMPLE C7 FOR 3RD COLUMN, 7TH ROW."
        print "EVERY SQUARE TO ITS RIGHT AND BELOW IS EATEN."
        print "DON'T EAT THE POISON! (P)"

        ' Initialize cookie
10      n = 81
        for i = 1 to 9
                for j = 1 to 9
                        a(i, j) = 1
                next j
        next i

        ' Poison the cookie
        a(1, 1) = -1

        ' Display initial cookie
        gosub 200

        ' Input move
        goto 30
20      print "ILLEGAL MOVE"
30      print
        print "YOUR MOVE";
        input m$

        ' Has to be two characters
        if len(m$) <> 2 goto 20
        m1 = asc(left$(m$, 1))
        m2 = asc(right$(m$, 1))

        ' First character has to be A through I
        ' Second character has to be numeric 1 through 9
        if m1 < 65 or m1 > 73 or m2 < 49 or m2 > 57 goto 20

        ' Row and column of chomp
        c = m1 - 65 + 1
        r = m2 - 49 + 1
        v = a(r, c)

        ' Can't chomp thin air
        if v = 0 goto 20

        ' Player chomped on the poison?
        if v < 0 goto 50

        ' Chomp cookie
        gosub 100

        ' Display remaining cookie
        gosub 200

	' Count edge cells
	gosub 300

        ' Figure out computer's move
        gosub 400
        m$ = chr$(65 + c - 1) + chr$(49 + r - 1)
        print
        print "COMPUTER MOVE? "; m$

        ' Chomp cookie
        gosub 100

        ' Did player win?
        if n = 0 goto 40

        ' Display cookie
        gosub 200

        ' Next move
        goto 30

        ' Player wins
40      print
        print "PLAYER WINS!"
        goto 10

        ' Computer wins
50      print
        print "COMPUTER WINS!"
        goto 10

' Chomp cookie
100     for i = r to 9
                for j = c to 9
                        if a(i, j) <> 0 then
                                a(i, j) = 0
                                n = n - 1
                        end if
                next j
        next i
        return

' Display cookie
200	print
        print "   A B C D E F G H I"
        for i = 1 to 9
                print i;
                for j = 1 to 9
                        b$ = "*"
                        if a(i, j) = 0 then
                                b$ = " "
                        end if
                        if a(i, j) < 0 then
                                b$ = "P"
                        end if
                        print b$; " ";
                next j
                print
        next i
	return

' Count edge cells
300     n1 = 0
        n2 = 0
        for i = 2 to 9
                n1 = n1 + a(i, 1)
                n2 = n2 + a(1, i)
        next i
        return

' Generate computer's move
400	s = a(2, 1) * 4 + a(2, 2) * 2 + a(1, 2) + 1
        on s goto 410, 420, 440, 440, 430, 440, 440, 440

        ' Eat the poison if there's no other choice
410	r = 1
        c = 1
        return 

        ' If you can, take all but the poison
420	r = 1
        c = 2
        return
430	r = 2
        c = 1 
        return

	' If the A column and 1 row have the same length, take B2 if you can
440	if (n1 <> n2) or (a(2, 2) = 0) goto 450
	r = 2
	c = 2
	return

        ' Try to mirror player's move
450	t = r
        r = c
        c = t
        if a(r, c) <= 0 goto 460
        return

        ' Choose a random legal move
460	r = int(9 * rnd(0)) + 1
        c = int(9 * rnd(0)) + 1
        if a(r, c) <= 0 goto 460
        return

        ' Reset the machine
500	poke &h71, 0
        exec &h8c1b
