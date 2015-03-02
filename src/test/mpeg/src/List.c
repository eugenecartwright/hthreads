/*
 * List.cpp
 *
 *  Created on: Nov 22, 2010
 *      Author: fyonga
 */

#include "Jpeg.h"

List* push(List* Queue, SYMBOL Elt)
{
	if(!Queue->previous)
	{
		Queue->content = Elt;
		Queue->previous = Queue;
		return Queue;
	}
	List* cur = (List*)malloc(sizeof(List));
	cur->content  = Elt;
	cur->next     = NULL;
	cur->previous = Queue;
	Queue->next   = cur;
	return cur;
}

List_int* push_int(List_int* Queue, uint8_t Elt)
{
	if(!Queue->previous)
	{
		Queue->content = Elt;
		Queue->previous = Queue;
		return Queue;
	}
	List_int* cur = (List_int*)malloc(sizeof(List_int));
	cur->content  = Elt;
	cur->next     = NULL;
	cur->previous = Queue;
	Queue->next   = cur;
	return cur;
}

