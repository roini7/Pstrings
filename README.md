# University Computer Structure Project - Pstrings Library Functions

Welcome to the Computer Structure course project on implementing Pstrings library functions in assembly code. This README will guide you through the project and explain how to use the provided library functions to manipulate Pstrings.

## Table of Contents
- [Introduction](#introduction)
- [Project Setup](#project-setup)
- [Usage](#usage)
- [Available Functions](#available-functions)
- [Examples](#examples)

## Introduction

In this project, you will be working with Pstrings, a custom data structure designed for efficient string manipulation in assembly code. A Pstring consists of a string and a number indicating the length of the string, separated by a space. The library functions you will be implementing allow you to perform various operations on these Pstrings.  
*note that the struct for the pstring used for this project is as follows:*  
![image](https://github.com/roini7/Pstrings/assets/60584742/a7fd6343-94ac-4a2d-b1fc-37bb1faab300)  

## Project Setup

To get started with this project, follow these steps:

1. Clone the project repository to your local machine:

   ```shell
   git clone https://github.com/your-username/computer-structure-project.git
   cd computer-structure-project
   ```

2. Compile the project using the `make` command:

   ```shell
   make
   ```

## Usage

To run the project, execute the following command in your command line interface:

```shell
./ex3.out pstring1 pstring2 option
```

Here's what each argument means:

- `pstring1`: The first Pstring you want to manipulate.
- `pstring2`: The second Pstring (used for some operations).
- `option`: The operation you want to perform on the Pstrings (see available options below).

## Available Functions

The following library functions are available for Pstring manipulation:

1. **Calculate Length (Option 31)**:
   - Calculates the length of a Pstring.
   
2. **Replace Characters (Options 32 or 33)**:
   - Replaces an old character with a new character in a Pstring. You will be prompted to input the old character and the new character.

3. **Copy String Interval (Option 35)**:
   - Copies a string interval from one Pstring to another Pstring with the same interval. Make sure the specified indexes are within the string limits to avoid errors.

4. **Swap Case (Option 36)**:
   - Swaps all uppercase letters to lowercase and vice versa in a Pstring.

5. **String Comparison (Option 37)**:
   - Compares two Pstrings lexicographically by ASCII values within a specified interval `[i:j]`. It returns:
      - `1` if `pstring1 > pstring2`
      - `-1` if `pstring1 < pstring2`
      - `0` if `pstring1 == pstring2`

## Examples

Here are some examples of how to use the Pstring library functions:

- Calculate the length of `pstring1` and `pstring2`:  
![image](https://github.com/roini7/Pstrings/assets/60584742/3565757e-7a27-40a8-917c-06769ec3799a)  

- Replace all 'e' characters with 'z' in `pstring1` and `pstring2`:  
  ![image](https://github.com/roini7/Pstrings/assets/60584742/18e2b4e6-16f2-484e-b67b-63bd6664f94a)  

- Copy the interval `[1:4]` from `pstring1` to `pstring2`:  
  ![image](https://github.com/roini7/Pstrings/assets/60584742/fb2c6da0-3040-4c56-9f76-0eac425c6166)  

- Swap the case of characters in `pstring1` and `pstring2`:  
![image](https://github.com/roini7/Pstrings/assets/60584742/eab6d4b8-841a-4a14-bf04-c7fd1b6495b3)  
![image](https://github.com/roini7/Pstrings/assets/60584742/0cc83481-b80f-4ae0-8763-aad0211d7752)  

- Compare `pstring1` and `pstring2` within the interval `[1:10]`:  
  ![image](https://github.com/roini7/Pstrings/assets/60584742/fd5a5fbb-321f-460d-9530-b55b67121f6f)  


Feel free to explore and experiment with the Pstring library functions. Happy coding!
