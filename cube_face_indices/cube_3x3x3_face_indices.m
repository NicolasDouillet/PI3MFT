function F_new = cube_3x3x3_face_indices(pattern_id)
%
% Author : nicolas.douillet (at) free.fr, 2017-2024.


switch pattern_id
    
    case 1 % Menger sponge
        
        F_new = [1 2 6 5; % Top layer top right corner cube
            17 18 22 21;
            1 5 21 17;
            2 1 17 18;
            6 2 18 22;
            5 6 22 21;...
            
            2 3 7 6; % Top layer top cross cube
            18 19 23 22;
            2 6 22 18;
            3 2 18 19;
            7 3 19 23;
            6 7 23 22;...
            
            3 4 8 7; % Top layer top left corner cube
            19 20 24 23;
            3 7 23 19;
            4 3 19 20;
            8 4 20 24;
            7 8 24 23;...
            
            5 6 10 9; % Top layer right cross cube
            21 22 26 25;
            5 9 25 21;
            6 5 21 22;
            10 6 22 26;
            9 10 26 25;...
            
            7 8 12 11; % Top layer left cross cube
            23 24 28 27;
            7 11 27 23;
            8 7 23 24;
            12 8 24 28;
            11 12 28 27;...
            
            9 10 14 13; % Top layer bottom right corner cube
            25 26 30 29;
            9 13 29 25;
            10 9 25 26;
            14 10 26 30;
            13 14 30 29;...
            
            10 11 15 14; % Top layer bottom cross cube
            26 27 31 30;
            10 14 30 26;
            11 10 26 27;
            15 11 27 31;
            14 15 31 30;...
            
            11 12 16 15; % Top layer bottom left corner cube
            27 28 32 31;
            11 15 31 27;
            12 11 27 28;
            16 12 28 32;
            15 16 32 31;...
            
            17 18 22 21; % Middle layer top right corner cube
            33 34 38 37;
            17 21 37 33;
            18 17 33 34;
            22 18 34 38;
            21 22 38 37;...
            
            19 20 24 23; % Middle layer top left corner cube
            35 36 40 39;
            19 23 39 35;
            20 19 35 36;
            24 20 36 40;
            23 24 40 39;...
            
            25 26 30 29; % Middle layer bottom right corner cube
            41 42 46 45;
            25 29 45 41;
            26 25 41 42;
            30 26 42 46;
            29 30 46 45;...
            
            27 28 32 31; % Middle layer bottom left corner cube
            43 44 48 47;
            27 31 47 43;
            28 27 43 44;
            32 28 44 48;
            31 32 48 47;...
            
            33 34 38 37; % Bottom layer top right corner cube
            49 50 54 53;
            33 37 53 49;
            34 33 49 50;
            38 34 50 54;
            37 38 54 53;...
            
            34 35 39 38; % Bottom layer top cross cube
            50 51 55 54;
            34 38 54 50;
            35 34 50 51;
            39 35 51 55;
            38 39 55 54;...
            
            35 36 40 39; % Bottom layer top left corner cube
            51 52 56 55;
            35 39 56 51;
            36 35 51 52;
            40 36 52 56;
            39 40 56 55;...
            
            37 38 42 41; % Bottom layer right cross cube
            53 54 58 57;
            37 41 57 53;
            38 37 53 54;
            42 38 54 58;
            41 42 58 57;...
            
            39 40 44 43; % Bottom layer left cross cube
            55 56 60 59;
            39 43 59 55;
            40 39 55 56;
            44 40 56 60;
            43 44 60 59;...
            
            41 42 46 45; % Bottom layer bottom right corner cube
            57 58 62 61;
            41 45 61 57;
            42 41 57 58;
            46 42 58 62;
            45 46 62 61;...
            
            42 43 47 46; % Bottom layer bottom cross cube
            58 59 63 62;
            42 46 62 58;
            43 42 58 59;
            47 43 59 63;
            46 47 63 62;...
            
            43 44 48 47; % Bottom layer bottom left corner cube
            59 60 64 63;
            43 47 63 59;
            44 43 59 60;
            48 44 60 64;
            47 48 64 63];
        
    case 2 % Koch snowflake
        
        F_new = [1 2 5 4; % Top layer top cross cube
            14 15 19 18;
            1 4 18 14;
            2 1 14 15;
            5 2 15 19;
            4 5 19 18;...
            
            3 4 8 7; % Top layer right cross cube
            17 18 22 21;
            3 7 21 17;
            4 3 17 18;
            8 4 18 22;
            7 8 22 21;...
            
            4 5 9 8; % Top layer centre cross cube
            18 19 23 22;
            4 8 22 18;
            5 4 18 19;
            9 5 19 23;
            8 9 23 22;...
            
            5 6 10 9; % Top layer left cross cube
            19 20 24 23;
            5 9 23 19;
            6 5 19 20;
            10 6 20 24;
            9 10 24 23;...
            
            8 9 12 11; % Top layer bottom cross cube
            22 23 27 26;
            8 11 26 22;
            9 8 22 23;
            12 9 23 27;
            11 12 27 26;...
            
            13 14 18 17; % Middle layer top right square cube
            29 30 34 33;
            13 17 33 29;
            14 13 29 30;
            18 14 30 34;
            17 18 34 33;...
            
            14 15 19 18; % Middle layer top cross cube
            30 31 35 34;
            14 18 34 30;
            15 14 30 31;
            19 15 31 35;
            18 19 35 34;...
            
            15 16 20 19; % Middle layer top left square cube
            31 32 36 35;
            15 19 35 31;
            16 15 31 32;
            20 16 32 36;
            19 20 36 35;...
            
            17 18 22 21; % Middle layer right cross cube
            33 34 38 37;
            17 21 37 33;
            18 17 33 34;
            22 18 34 38;
            21 22 38 37;...
            
            19 20 24 23; % Middle layer left cross cube
            35 36 40 39;
            19 23 39 35;
            20 19 35 36;
            24 20 36 40;
            23 24 40 39;...
            
            21 22 26 25; % Middle layer bottom right square cube
            37 38 42 41;
            21 25 41 37;
            22 21 37 38;
            26 22 38 42;
            25 26 42 41;...
            
            22 23 27 26; % Middle layer bottom cross cube
            38 39 43 42;
            22 26 42 38;
            23 22 38 39;
            27 23 39 43;
            26 27 43 42;...
            
            23 24 28 27; % Middle layer bottom left square cube
            39 40 44 43;
            23 27 43 39;
            24 23 39 40;
            28 24 40 44;
            27 28 44 43;...
                        
            30 31 35 34; % Bottom layer top cross cube
            45 46 49 48;
            30 34 48 45;
            31 30 45 46;
            35 31 46 49;
            34 35 49 48;...
            
            33 34 38 37; % Bottom layer right cross cube
            47 48 52 51;
            33 37 51 47;
            34 33 47 48;
            38 34 48 52;
            37 38 52 51;...
            
            34 35 39 38; % Bottom layer centre cross cube
            48 49 53 52;
            34 38 52 48;
            35 34 48 49;
            39 35 49 53;
            38 39 53 52;...
            
            35 36 40 39; % Bottom layer left cross cube
            49 50 54 53;
            35 39 53 49;
            36 35 49 50;
            40 36 50 54;
            39 40 54 53;...
            
            38 39 43 42; % Bottm layer bottom cross cube
            52 53 56 55;
            38 42 55 52;
            39 38 52 53;
            43 39 53 56;
            42 43 56 55];
                
    case 3
                
        F_new = [1 2 6 5; % Top layer top right corner cube
            17 18 22 21;
            1 5 21 17;
            2 1 17 18;
            6 2 18 22;
            5 6 22 21;...                        
            
            3 4 8 7; % Top layer top left corner cube
            19 20 24 23;
            3 7 23 19;
            4 3 19 20;
            8 4 20 24;
            7 8 24 23;...                                                
            
            9 10 14 13; % Top layer bottom right corner cube
            25 26 30 29;
            9 13 29 25;
            10 9 25 26;
            14 10 26 30;
            13 14 30 29;...                        
            
            11 12 16 15; % Top layer bottom left corner cube
            27 28 32 31;
            11 15 31 27;
            12 11 27 28;
            16 12 28 32;
            15 16 32 31;...
            
            % Middle layer central cube
                        
            22 23 27 26;...
            38 39 43 42;...
            22 26 42 38;...
            23 22 38 39;...
            27 23 39 43;...
            26 27 43 42;...            
            
            33 34 38 37; % Bottom layer top right corner cube
            49 50 54 53;
            33 37 53 49;
            34 33 49 50;
            38 34 50 54;
            37 38 54 53;...                        
            
            35 36 40 39; % Bottom layer top left corner cube
            51 52 56 55;
            35 39 56 51;
            36 35 51 52;
            40 36 52 56;
            39 40 56 55;...                                    
            
            41 42 46 45; % Bottom layer bottom right corner cube
            57 58 62 61;
            41 45 61 57;
            42 41 57 58;
            46 42 58 62;
            45 46 62 61;...                        
            
            43 44 48 47; % Bottom layer bottom left corner cube
            59 60 64 63;
            43 47 63 59;
            44 43 59 60;
            48 44 60 64;
            47 48 64 63];
                
    otherwise % 5x5x5 et Sierpinski impossibles
        
        error('Unsupported pattern identifier.');
        
end


end