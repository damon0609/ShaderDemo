using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class WorldSpaceDemo01 : MonoBehaviour {

    public Vector3 targetPos;
    public float length;
    Transform cache;

    private Vector3 pos;
    private Vector3 angle;

    private bool isUpdate = false;

    private Vector3 objFwd;
    private Vector3 rightDir;
    private Vector3 upDir;

    public float fwdAngle = 45;
    private Vector3 customFwd;
    private void OnDrawGizmos () {
        isUpdate = true;
        if (cache == null) {
            cache = transform;
        }
        if (pos != cache.position || angle != cache.eulerAngles) {
            pos = cache.position;
            angle = cache.eulerAngles;
            isUpdate = true;
        } else {
            isUpdate = false;
        }
        if (isUpdate) {
            Quaternion rotation = Quaternion.Euler (angle);
            objFwd = rotation * Vector3.forward;
            upDir = rotation * Vector3.up;
            rightDir = rotation * Vector3.right;

            //自定义前方
            customFwd = cache.rotation * Quaternion.Euler (0, fwdAngle, 0) * Vector3.forward;
        }
        Gizmos.color = Color.red;
        Gizmos.DrawLine (pos, objFwd.normalized * length + pos);
        Gizmos.color = Color.blue;
        Gizmos.DrawLine (pos, pos + upDir * length);
        Gizmos.color = Color.green;
        Gizmos.DrawLine (pos, pos + rightDir * length);

        Gizmos.color = Color.yellow;
        Gizmos.DrawLine (pos, pos + customFwd * length);
        Gizmos.DrawSphere (pos + customFwd * length,0.1f);
        Gizmos.color = Color.white;

    }

    void Start () {

    }

    // Update is called once per frame
    void Update () {

    }
}