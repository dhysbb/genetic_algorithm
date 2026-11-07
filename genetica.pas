program pro1;
uses math;
const a = 0;
	b = 4;
	n = 16383;
	m = 10;
	len_bit = 14;
	
type arr1 = array[0..n] of real;
	arr2 = array[0..m] of real;
	binary = array[1..len_bit] of integer;
	t = record
		num: real;
		zn: real;
		flag: integer;
		bin: binary;
	end;
	arr3 = array[0..m] of t;
	TMask = array[1..len_bit] of Integer;

var m1: arr1;
	m2, popul, popul_zn: arr2;
	i, j, k, kolvo_scr, kolvo_mutacia, kolvo_iter, s, test_regim: integer;
	l, r: integer;
	arr_sort: arr3;
	zn_f_ostanov, zn_sel_up, zn_sel_down: integer;
	maska: TMask;


function f(x:Real):Real; begin f:=(x - 3) * (x - 2) * (x - 0.01)**4 * (x - 3.98)**4 * (1 - exp(x-2.5)) * sin(2 * x + 0.2) end;


procedure sort(var arr: arr3);
var p: t;
	i: integer;
begin
	for i := 0 to m do begin
		for j := 0 to (m - i - 1) do begin
			if arr[j].zn < arr[j+1].zn then begin
				p.num := arr[j].num;
				p.zn := arr[j].zn;
				arr[j].num := arr[j+1].num;
				arr[j].zn := arr[j+1].zn;
				arr[j+1].num := p.num;
				arr[j+1].zn := p.zn;
			end;
		end;
	end;
end;


procedure check_ostanov(var arr: arr3; zn_f: integer);
var i, j: integer;
begin
	j := 0;
	for i:= 0 to m do begin
		if arr[i].zn >= zn_f then begin writeln(arr[i].num : 5 : 5, ':   ', arr[i].zn : 5 : 5); j := j + 1; end
		else break;		
	end;
	if j <> 0 then begin writeln('kolvo iter:  ', kolvo_iter); halt(); end;
end;


procedure selecia(var arr: arr3; zn_sel_up, zn_sel_down: integer);
var i: integer;
	sum : real;
begin
	sum := 0;
	for i := 0 to m do arr[i].flag := 1;
	for i := (zn_sel_up) to (m - zn_sel_down) do begin
		arr[i].flag := 0;
	end;
end;

function GenerateRandomMask: TMask;
var
  i: Integer;
  mask: TMask;
begin
  for i := 1 to len_bit do
    mask[i] := Random(2);  
  GenerateRandomMask := Mask;
end;

procedure to_binary(var arr: arr3);
var numm: integer;
	i, j: integer;
begin
	for i:= 0 to m do begin
		numm := round(arr[i].num);
		for j := len_bit downto 1 do begin
			if numm > 0 then begin
				arr[i].bin[j] := (numm mod 2);  
				numm := numm div 2;         
			end
			else arr[i].bin[j] := 0;
		end;
	end;
end;

procedure screch(var arr: arr3; kolvo_scr: integer; maska: TMask);
var n1, n2, n3, n4, i, q, p, kolvo_flag, ii: integer;
begin
	kolvo_flag :=0;
	for i := 1 to kolvo_scr do begin
		n1 := random(11);
		n2 := random(11);
		arr[n1].flag := 1;
		arr[n2].flag := 1;
		q := 1;
		p := 1;
		for ii := 0 to m do begin
			if arr[ii].flag = 0 then kolvo_flag :=kolvo_flag + 1;
		end;
		if kolvo_flag >= 2 then begin
			while (q = 1) or (p = 1) do begin
				if q = 1 then begin
					n3 := random(11);
					q := arr[n3].flag;
				end;
				if p = 1 then begin
					n4 := random(11);
					p := arr[n4].flag;
				end;
			end;
			for j := 1 to len_bit do begin
			if maska[j] = 1 then begin
				arr[n3].bin[j] := 1 - arr[n1].bin[j];
				arr[n4].bin[j] := 1 - arr[n2].bin[j];
			end
			else begin
				arr[n3].bin[j] := arr[n1].bin[j];
				arr[n4].bin[j] := arr[n2].bin[j];
			end;
		end;
		end
		else break;
	end;
end;
		
procedure mutacia(var arr: arr3; kolvo_mutacia, p: integer);
var i, j, n1, n2, n3, temp: integer;
begin
	for i := 1 to kolvo_mutacia do begin
		n1 := random(14);
		n1 := n1 + 1;
		n2 := random(14);
		n2 := n2 + 1;
		n3 := p;
		if n3 = -1 then n3 := random(11);
		while (n3 < zn_sel_up) or (n3 > (10 - zn_sel_down)) do n3 := random(11);
		temp := arr[n3].bin[n1];
		arr[n3].bin[n1] := arr[n3].bin[n2];
		arr[n3].bin[n2] := temp;
	end;
end;

procedure check_dubl(var arr: arr3);
var i, j, k, flag: integer;
begin
	for i := 0 to m do begin
		for j := (i + 1) to m do begin
			flag := 0;
			for k := 1 to len_bit do begin
				if arr[i].bin[k] = arr[j].bin[k] then flag := flag + 1;
			end;
			if flag = 14 then begin
				if j > (10 - zn_sel_down) then mutacia(arr, 1, i)
				else if i < zn_sel_up then mutacia(arr, 1, j)
				else mutacia(arr, 1, i);
			end;
		end;
	end;
end;

procedure noviy_zn(var arr: arr3);
var i, j, k: integer;
	sum: real;
begin
	for i := 0 to m do begin
		sum := 0;
		for j := 1 to len_bit do begin
			sum := sum * 2;
			if arr[i].bin[j] = 1 then sum := sum + 1;
		end;
		arr[i].num := sum;
	end;
	for i := (zn_sel_up) to (m - zn_sel_down) do begin
		arr[i].flag := 0;
	end; 
end;

begin
	kolvo_iter := 0;
	writeln('please write zn_f_ostanov');
	readln(zn_f_ostanov);
	writeln('please write zn_sel_up, zn_sel_down');
	readln(zn_sel_up, zn_sel_down);
	writeln('write kolvo screch');
	read(kolvo_scr);
	writeln('write kolvo mutaciy');
	read(kolvo_mutacia);
	writeln('type of regim: test(1) or norm(0)');
	read(test_regim);
	for i := 0 to n do begin
		m1[i] := b * i/n;
	end;
	for i := 0 to m do begin
		m2[i] := b * i / m;
	end;
	k := 0;
	for i := 0 to m do begin
		l := trunc(n*i/m);
		r := l + 1;
		if r > n then begin popul[k] := n; break; end
		else if (m2[i] >= m1[l]) and (m2[i] <= m1[r]) then begin
			if m2[i] - m1[l] > m1[r] -  m2[i] then begin
				popul[k] := r;
			end
			else begin
				popul[k] := l;
			end;
			k := k + 1;
		end;
	end;
	for k := 0 to m do begin
		popul_zn[k] := f(b*popul[k]/n);
	end;
	for k := 0 to m do begin
		arr_sort[k].num := popul[k];
		arr_sort[k].zn := popul_zn[k];
		if test_regim = 1 then writeln(arr_sort[k].num : 5 : 5, ':   ', arr_sort[k].zn : 5 : 5);
	end;
	writeln('vvedi s');
	read(s);
	while s = 1 do begin
		sort(arr_sort);
		if test_regim = 1 then begin
			writeln();
			for k := 0 to m do begin
				writeln(arr_sort[k].num : 5 : 5, ':   ', arr_sort[k].zn : 5 : 5);
			end;
			writeln('znach ostanov');
		end;
		check_ostanov(arr_sort, zn_f_ostanov);
		kolvo_iter := kolvo_iter + 1;
		selecia(arr_sort, zn_sel_up, zn_sel_down);
		if test_regim = 1 then begin 
			writeln('after selecia');
			for k := 0 to m do begin
				writeln(arr_sort[k].num : 5 : 5, ':   ', arr_sort[k].zn : 5 : 5, '  ', arr_sort[k].flag);
			end;
			writeln('to bin');
		end;
		maska := GenerateRandomMask;
		
		to_binary(arr_sort);
		if test_regim = 1 then begin
			for k := 0 to m do begin
				write(arr_sort[k].num : 5 : 5, ':   ');
				for j := 1 to len_bit do begin
					write(arr_sort[k].bin[j]);
				end;
				writeln();
			end;
			writeln('after screch');
		end;
		
		screch(arr_sort, kolvo_scr, maska);
		if test_regim = 1 then begin
			for k := 0 to m do begin
				write(arr_sort[k].num : 5 : 5, ':   ');
				for j := 1 to len_bit do begin
					write(arr_sort[k].bin[j]);
				end;
				writeln();
			end;
			writeln('after mutacia');
		end;
		mutacia(arr_sort, kolvo_mutacia, -1);
		if test_regim = 1 then begin
			for k := 0 to m do begin
				write(arr_sort[k].num : 5 : 5, ':   ');
				for j := 1 to len_bit do begin
					write(arr_sort[k].bin[j]);
				end;
				writeln();
			end;
			writeln('after check dubl');
		end;
		check_dubl(arr_sort);
		if test_regim = 1 then writeln('after noviy znach');
		noviy_zn(arr_sort);
		if test_regim = 1 then begin
			for k := 0 to m do begin
				write(arr_sort[k].num : 5 : 5, ':   ');
				for j := 1 to len_bit do begin
					write(arr_sort[k].bin[j]);
				end;
				writeln();
			end;
		end;
		for k:= 0 to m do begin
			if zn_f_ostanov < f(round(arr_sort[k].num)*b/n) then arr_sort[k].zn := zn_f_ostanov
			else arr_sort[k].zn := f(round(arr_sort[k].num)*b/n);
			if test_regim = 1 then writeln(arr_sort[k].zn);
		end;
		if test_regim = 1 then begin
			for k := 0 to m do begin
				writeln(arr_sort[k].num:5:5, ':   ', arr_sort[k].zn:5:5);
			end;
		end;
	end;
end.
