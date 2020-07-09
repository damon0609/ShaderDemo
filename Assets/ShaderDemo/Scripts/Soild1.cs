using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Soild1 : MonoBehaviour
{
    private Material material;
    public float speed = 0.1f;
    private float timer;
    void Start()
    {
        material = GetComponent<MeshRenderer>().material;
    }

    void Update()
    {
        timer+=(Time.deltaTime*speed);
        if(timer<=10f)
        {
            material.SetFloat("_Size", timer);
        }
    }
}
