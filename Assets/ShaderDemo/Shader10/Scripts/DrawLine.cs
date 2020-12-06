using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DrawLine : MonoBehaviour {
    public Material material;
    public List<Vector3> points;
    void Start () {
        points = new List<Vector3> ();
    }
    void Update () {
        Ray ray = Camera.main.ScreenPointToRay (Input.mousePosition);
        RaycastHit hit;
        if (Input.GetMouseButton (0)) {
            if (Physics.Raycast (ray.origin, ray.direction, out hit)) {
                if (AddPoint (hit.point)) {
                    points.Add (hit.point);
                    OptimizedPos ();
                }
            }
        }
    }

    private void OnGUI() {
        if(GUILayout.Button("Clear Points"))
        {
            points.Clear();
        }
    }

    void OptimizedPos () {
        if (points.Count >= 2) {
            Vector3 prePos = points[points.Count - 2];
            Vector3 lastPos = points[points.Count - 1];
            float distance = Vector3.Distance (prePos, lastPos);
            Vector3 dir = (lastPos - prePos).normalized;
            if (distance >= 0.5f) {
                lastPos = prePos + dir * 0.5f;
                points[points.Count - 1] = lastPos;
            }
        }
    }

    bool AddPoint (Vector3 point) {
        bool added = false;
        if (points != null) {
            if (points.Count == 0) {
                added = true;
            } else {
                Vector3 prePos = points[points.Count - 1];
                float distance = Vector3.Distance (prePos, point);
                if (distance >= 0.2f)
                    added = true;
            }
        }
        return added;
    }

    private void OnDrawGizmos () {
        if (points != null) {
            Gizmos.color = Color.black;
            foreach (Vector3 pos in points) {
                Gizmos.DrawSphere (pos, 0.1f);
            }
            Gizmos.color = Color.white;
        }
    }
}