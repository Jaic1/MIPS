int kmp(){
    int i, j, k;
    int lp, ls;
    char p[100], s[100];
    int cnt = 0;
    int result[100];

    
    for(j = 0;j < ls;j++){
        for(i = 0;i < lp;i++){
            k = i+j;
            if(k == ls) goto A;
            if(p+1[i] != s+1[k]) goto A;  
        }
        result[cnt++] = j+1;
        A
    }

    return 0;
}

