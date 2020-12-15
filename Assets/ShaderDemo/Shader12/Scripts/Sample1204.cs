using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Sample1204 : MonoBehaviour {
    [SerializeField]
    private Material material;

    private bool on = false;
    public float radius = 0.0f;
    private int materialID;
    void Start () {
        materialID = Shader.PropertyToID ("_Radius");
    }
    void Update () {
        if (Input.GetKeyDown (KeyCode.Space) && !on) {
            on = true;
        } 

        if (on) {
            float result = 5 * Mathf.Sin (Mathf.Deg2Rad * (radius++)) + 20 - 15;
            material.SetFloat (materialID, result);
        }
    }
}