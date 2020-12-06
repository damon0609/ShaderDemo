using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GetObjectPoint : MonoBehaviour {

    public Material material;
    void Start () {

    }
    void Update () {
        Ray ray = Camera.main.ScreenPointToRay (Input.mousePosition);
        RaycastHit hit;
        if (Input.GetMouseButton(0)) {
            if (Physics.Raycast (ray.origin, ray.direction, out hit)) {
                material.SetVector ("worldPos", hit.point);
                material.SetFloat ("_Threshold", 0.1f);
            }
        } else {
            material.SetFloat ("_Threshold", 0.0f);
        }
    }
}