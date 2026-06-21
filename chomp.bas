' CHOMP by Rick Adams 

        dim a(9, 9)

        ' Randomize the RND function
        r = rnd(-timer)

        ' Reset machine on BREAK
        on brk goto 2000

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
        gosub 1000

        ' Input move
        goto 40
30      print "ILLEGAL MOVE"
40      print
        print "YOUR MOVE";
        input m$

        ' Has to be two characters
        if len(m$) <> 2 then
                goto 30
        end if
        m1 = asc(left$(m$, 1))
        m2 = asc(right$(m$, 1))

        ' First character has to be A through I
        ' Second character has to be numeric 1 through 9
        if m1 < 65 or m1 > 73 or m2 < 49 or m2 > 57 then
                goto 30
        end if

        ' Row and column of chomp
        c = m1 - 65 + 1
        r = m2 - 49 + 1
        v = a(r, c)

        ' Can't chomp thin air
        if v = 0 then
                goto 30
        end if

        ' Player chomped on the poison?
        if v < 0 then
                goto 100
        end if

        ' Chomp cookie
        gosub 500

        ' Display remaining cookie
        gosub 1000

        ' Figure out computer's move
        gosub 1500
        m$ = chr$(65 + c - 1) + chr$(49 + r - 1)
        print
        print "COMPUTER MOVE? "; m$

        ' Chomp cookie
        gosub 500

        ' Did player win?
        if n = 0 then
                goto 90
        end if

        ' Display cookie
        gosub 1000

        ' Next move
        goto 40

        ' Player wins
90      print
        print "PLAYER WINS!"
        goto 10

        ' Computer wins
100     print
        print "COMPUTER WINS!"
        goto 10

' Chomp cookie
500     for i = r to 9
                for j = c to 9
                        if a(i, j) <> 0 then
                                a(i, j) = 0
                                n = n - 1
                        end if
                next j
        next i
        return

' Display cookie
1000    print
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

' Generate computer's move
1500    s = a(2, 1) * 4 + a(2, 2) * 2 + a(1, 2) + 1
        on s goto 1570, 1571, 1577, 1577, 1574, 1577, 1577, 1577

        ' Eat the poison if there's no other choice
1570    r = 1
        c = 1
        return 

        ' If you can, take all but the poison
1571    r = 1
        c = 2
        return
1574    r = 2
        c = 1 
        return

        ' Try to mirror player's move
1577    t = r
        r = c
        c = t
        if a(r, c) <= 0 then
		goto 1583
	end if
        return

        ' Choose a random legal move
1583    r = int(9 * rnd(0)) + 1
        c = int(9 * rnd(0)) + 1
        if a(r, c) <= 0 then
		goto 1583
	end if
        return

        ' Reset the machine
2000    poke &h71, 0
        exec &h8c1b
