using System.Collections;
using System.Collections.Generic;
using UnityEditor;
using UnityEngine;
public class UVDot : MonoBehaviour {

    public bool isShow = false;
    public Material material;

    [ContextMenu ("TestUV")]
    void TestUV () {
        uvs = new List<Vector2> ();
        for (float v = 0; v < 1; v += 0.2f) {
            for (float u = 0; u < 1; u += 0.2f) {
                Vector2 uv = new Vector2 (u, v);
                uvs.Add (uv - new Vector2 (0.5f, 0.5f));
            }
        }
    }
    private List<Vector2> uvs = new List<Vector2> ();
    private void OnDrawGizmos () {
        if (uvs == null || !isShow) return;
        for (int i = 0; i < uvs.Count; i++) {
            Gizmos.DrawSphere (uvs[i], 0.01f);
            float result = Vector2.Dot (uvs[i], new Vector2 (1, 0));
            if (result < 0 || result > 1) {
                Gizmos.color = Color.black;
            } else {
                Gizmos.color = Color.red;
            }
            Gizmos.DrawSphere (uvs[i], 0.1f);
        }
    }

    public Vector2[] edges;
    public int index;
    private bool on = true;
    void Start () {
        Vector4[] temp = new Vector4[4] { edges[0], edges[1], edges[2], edges[3] };
        material.SetVectorArray ("_edges", temp);
        // StartCoroutine (Timer ());
    }
    IEnumerator Timer () {
        while (on) {
            yield return new WaitForSeconds (1.0f);
            index++;
            int n = index % edges.Length;
            material.SetInt ("_index", n);
        }
    }
    private void OnDestroy () {
        on = false;
    }

    void Update () {
        material.SetInt ("_index", index);
    }
}