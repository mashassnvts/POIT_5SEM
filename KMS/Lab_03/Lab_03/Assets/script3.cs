using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.EventSystems; 

public class script3 : MonoBehaviour, IPointerClickHandler 
{
    public void OnPointerClick(PointerEventData eventData)
    {
        Debug.Log("Куб был щелкнут!"); 
                                       
        float red = Random.Range(0.0f, 1.0f);
        float green = Random.Range(0.0f, 1.0f);
        float blue = Random.Range(0.0f, 1.0f);

        Color col1 = new Color(red, green, blue);

        gameObject.GetComponent<Renderer>().material.color = col1;
    }
}
